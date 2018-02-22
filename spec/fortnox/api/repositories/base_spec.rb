# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API::Repository::Base do
  using_test_class do
    module Model
      class Test
      end
    end
    module Repository
      class Test < Fortnox::API::Repository::Base
        MODEL = Model::Test
      end
    end

    require 'dry/container/stub'
    Fortnox::API::Registry.enable_stubs!
    Fortnox::API::Registry.stub(:test, Model::Test)
  end

  let(:access_token) { '3f08d038-f380-4893-94a0-a08f6e60e67a' }
  let(:access_token2) { '89feajou-sif8-8f8u-29ja-xdfniokeniod' }
  let(:client_secret) { 'P5K5vE3Kun' }
  let(:repository) { Repository::Test.new }
  let(:application_json) {}
  let(:headers) do
    {
      'Access-Token' => access_token,
      'Client-Secret' => client_secret,
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  describe 'creation' do
    shared_examples_for 'missing configuration' do
      subject { -> { repository } }

      let(:error) { Fortnox::API::MissingConfiguration }

      it { is_expected.to raise_error(error, /#{message}/) }
    end

    context 'without base url' do
      include_examples 'missing configuration' do
        before { Fortnox::API.configure { |conf| conf.base_url = nil } }
        let(:message) { 'have to provide a base url' }
      end
    end

    context 'without client secret' do
      include_examples 'missing configuration' do
        before { Fortnox::API.configure { |conf| conf.client_secret = nil } }
        let(:message) { 'have to provide your client secret' }
      end
    end
  end

  describe '#next_access_token' do
    before { Fortnox::API.configure { |conf| conf.client_secret = client_secret } }

    context 'with default token store' do
      context 'with one access token' do
        subject { repository.next_access_token }

        before { Fortnox::API.configure { |conf| conf.access_token = access_token } }
        it { is_expected.to eql(access_token) }

        describe 'next request' do
          before { repository.next_access_token }

          it 'still uses the same token' do
            is_expected.to eql(access_token)
          end
        end
      end

      context 'with multiple access tokens' do
        subject { access_tokens }

        before { Fortnox::API.configure { |conf| conf.access_tokens = access_tokens } }
        let(:access_tokens) { [access_token, access_token2] }

        it { is_expected.to include(repository.next_access_token) }

        it 'changes token on next request' do
          token1 = repository.next_access_token
          token2 = repository.next_access_token

          expect(token1).not_to eql(token2)
        end

        it 'circulates tokens' do
          token1 = repository.next_access_token
          repository.next_access_token
          token3 = repository.next_access_token

          expect(token1).to eql(token3)
        end
      end
    end

    context 'with multiple stores' do
      subject { repository.next_access_token }

      before do
        Fortnox::API.configure do |config|
          config.access_tokens = { store1: access_token, store2: access_token2 }
        end
      end

      describe 'first token store' do
        let(:repository) { Repository::Test.new(token_store: :store1) }

        it { is_expected.to eql access_token }
      end

      describe 'second token store' do
        let(:repository) { Repository::Test.new(token_store: :store2) }

        it { is_expected.to eql access_token2 }
      end
    end
  end

  describe '#get_access_tokens' do
    subject(:get_access_tokens) { repository.get_access_tokens }

    before { Fortnox::API.configure { |conf| conf.client_secret = client_secret } }

    let(:token_store_not_present) { "no token store named #{token_store.inspect}." }
    let(:error) { Fortnox::API::MissingConfiguration }

    context 'with non existing token store' do
      subject { -> { get_access_tokens } }

      before do
        Fortnox::API.configure { |conf| conf.access_tokens = { some_store: [access_token] } }
      end

      let(:repository) { Repository::Test.new(token_store: token_store) }
      let(:token_store) { :non_existing_store }

      it { is_expected.to raise_error(error, /#{token_store_not_present}/) }
    end

    context 'with no tokens set' do
      subject { -> { get_access_tokens } }

      before { Fortnox::API.configure { |conf| conf.access_tokens = {} } }
      let(:token_store) { :default }

      it { is_expected.to raise_error(error, /#{token_store_not_present}/) }
    end

    context 'with one access token in token store' do
      before { Fortnox::API.configure { |conf| conf.access_token = access_token } }
      let(:token_store) { :default }

      it { is_expected.to eql(access_token) }
    end

    context 'with multiple access tokens' do
      before do
        Fortnox::API.configure { |conf| conf.access_tokens = [access_token, access_token2] }
      end
      let(:token_store) { :default }

      it { is_expected.to eql([access_token, access_token2]) }
    end

    context 'with multiple token stores' do
      before do
        Fortnox::API.configure do |conf|
          conf.access_tokens = { store_a: store_a_tokens, store_b: store_b_token }
        end
      end
      let(:store_a_tokens) { %w[token_a1 token_a2] }
      let(:store_b_token) { 'token_b1' }

      context 'with valid store name' do
        let(:repository) { Repository::Test.new(token_store: :store_a) }

        it { is_expected.to eql(store_a_tokens) }
      end

      context 'with non collection' do
        let(:repository) { Repository::Test.new(token_store: :store_b) }

        it { is_expected.to eql(store_b_token) }
      end

      context 'with invalid store name' do
        subject { -> { get_access_tokens } }

        let(:repository) { Repository::Test.new(token_store: :nonsence_store) }

        it { is_expected.to raise_error(error) }
      end
    end
  end

  describe '#check_access_tokens!' do
    subject { -> { repository.check_access_tokens!(tokens) } }

    before { Fortnox::API.configure { |conf| conf.client_secret = client_secret } }
    let(:error) { Fortnox::API::MissingConfiguration }
    let(:message) { "not provided any access tokens in token store #{token_store.inspect}" }
    let(:token_store) { :default }

    context 'with nil' do
      let(:tokens) { nil }

      it { is_expected.to raise_error(error, /#{message}/) }
    end

    context 'with empty array' do
      let(:tokens) { [] }

      it { is_expected.to raise_error(error, /#{message}/) }
    end

    context 'with an empty, non default, token store' do
      before { Fortnox::API.configure { |conf| conf.access_tokens = { token_store => tokens } } }
      let(:repository) { Repository::Test.new(token_store: token_store) }
      let(:tokens) { [] }
      let(:token_store) { :store1 }

      it { is_expected.to raise_error(error, /#{message}/) }
    end

    context 'with valid tokens' do
      let(:tokens) { %w[12345 abcde] }

      it { is_expected.not_to raise_error }
    end
  end

  context 'when making a request including the proper headers' do
    before do
      Fortnox::API.configure do |conf|
        conf.client_secret = client_secret
        conf.access_token = access_token
      end

      stub_request(
        :get,
        'https://api.fortnox.se/3/test'
      ).with(
        headers: headers
      ).to_return(
        status: 200
      )
    end

    subject { repository.get('/test', body: '') }

    it { is_expected.to be_nil }
  end

  describe 'making requests with multiple access tokens' do
    before do
      Fortnox::API.configure do |conf|
        conf.client_secret = client_secret
        conf.access_tokens = [access_token, access_token2]
      end

      stub_request(
        :get,
        'https://api.fortnox.se/3/test'
      ).with(
        headers: {
          'Access-Token' => access_token,
          'Client-Secret' => client_secret,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      ).to_return(
        status: 200,
        body: '1'
      )

      stub_request(
        :get,
        'https://api.fortnox.se/3/test'
      ).with(
        headers: {
          'Access-Token' => access_token2,
          'Client-Secret' => client_secret,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      ).to_return(
        status: 200,
        body: '2'
      )
    end

    context 'with subsequent requests on same object' do
      let!(:response1) { repository.get('/test', body: '') }
      let!(:response2) { repository.get('/test', body: '') }
      let!(:response3) { repository.get('/test', body: '') }

      # rubocop:disable RSpec/MultipleExpectations
      # All these checks must be run in same it-statement because
      # of the random starting index.
      it 'works' do
        expect(response1).not_to eq(response2)
        expect(response1).to eq(response3)
        expect(response3).not_to eq(response2)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  context 'when raising error from remote server' do
    error_message = 'Räkenskapsår finns inte upplagt. '\
                    'För att kunna skapa en faktura krävs det att det finns ett räkenskapsår'

    before do
      Fortnox::API.configure do |conf|
        conf.client_secret = client_secret
        conf.access_tokens = [access_token, access_token2]
      end

      stub_request(
        :post,
        'https://api.fortnox.se/3/test'
      ).to_return(
        status: 500,
        body: {
          'ErrorInformation' => {
            'error' => 1,
            'message' => error_message
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    subject { -> { repository.post('/test', body: '') } }

    it { is_expected.to raise_error(Fortnox::API::RemoteServerError) }
    it { is_expected.to raise_error(error_message) }

    context 'with debugging enabled' do
      around do |example|
        Fortnox::API.config.debugging = true
        example.run
        Fortnox::API.config.debugging = false
      end

      it { is_expected.to raise_error(/\<HTTParty\:\:Request\:0x/) }
    end
  end
end
