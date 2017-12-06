require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API::Repository::Base do
  using_test_class do
    module Model
      class Test
      end
    end
  end

  # Note: Could not get this to work with using_test_classes
  # I get Dry::Container::Error:
  # There is already an item registered with the key "test"
  #
  # It would be better to fix this, because below code is probably leaking to
  # other specs now...
  before(:all) do
    module Mapper
      class Test < Fortnox::API::Mapper::Base
        Fortnox::API::Registry.register( Test.canonical_name_sym, Test )
      end
    end
  end

  let(:access_token){ '3f08d038-f380-4893-94a0-a08f6e60e67a' }
  let(:access_token2){ '89feajou-sif8-8f8u-29ja-xdfniokeniod' }
  let(:client_secret){ 'P5K5vE3Kun' }
  let(:repository){ described_class.new( Model::Test ) }
  let(:application_json){}
  let(:headers) do
    {
      'Access-Token' => access_token,
      'Client-Secret' => client_secret,
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
    }
  end

  describe 'creation' do
    shared_examples_for 'missing configuration' do
      subject{ ->{ repository } }
      let(:error){ Fortnox::API::MissingConfiguration }

      it{ is_expected.to raise_error( error, /#{message}/ ) }
    end

    context 'without base url' do
      include_examples 'missing configuration' do
        before{ Fortnox::API.configure{ |conf| conf.base_url = nil } }
        let(:message){ 'have to provide a base url' }
      end
    end

    context 'without client secret' do
      include_examples 'missing configuration' do
        before{ Fortnox::API.configure{ |conf| conf.client_secret = nil } }
        let(:message){ 'have to provide your client secret' }
      end
    end
  end

  describe '#next_access_token' do
    before{ Fortnox::API.configure{ |conf| conf.client_secret = client_secret } }

    context 'with default token store' do
      context 'with one access token' do
        subject{ repository.next_access_token }
        before{ Fortnox::API.configure{ |conf| conf.token_store = { default: [access_token] } } }
        it{ is_expected.to eql( access_token ) }
      end

      context 'with multiple access tokens' do
        subject{ access_tokens }
        before{ Fortnox::API.configure{ |conf| conf.token_store = { default: access_tokens } } }
        let( :access_tokens ){ [access_token, access_token2] }

        it{ is_expected.to include( repository.next_access_token ) }

        # rubocop:disable RSpec/MultipleExpectations
        # All these checks must be run in same it-statement because
        # of the random starting index.
        it 'circulates the tokens' do
          token1 = repository.next_access_token
          token2 = repository.next_access_token
          token3 = repository.next_access_token

          expect( token1 ).to eql( token3 )
          expect( token1 ).not_to eql( token2 )
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context 'without token store (just access token)' do
        it 'should be tested'
      end

    end

    context 'with multiple stores' do
      subject{ repository.next_access_token }

      before do 
        Fortnox::API.configure do |config|
          config.token_store = { store1: access_token, store2: access_token2 }
        end
      end

      describe 'first token store' do
        let( :repository ){ described_class.new( Model::Test, token_store: :store1) }
        it{ is_expected.to eql access_token }
      end

      describe 'second token store' do
        let( :repository ){ described_class.new( Model::Test, token_store: :store2 ) }
        it{ is_expected.to eql access_token2 }
      end
    end
  end

  describe '#get_access_tokens' do
    subject(:get_access_tokens){ repository.get_access_tokens }

    before{ Fortnox::API.configure{ |conf| conf.client_secret = client_secret } }

    let(:token_store_not_present){ "#{ token_store } is not present in token store" }
    let(:error){ Fortnox::API::MissingConfiguration }

    context 'with non existing token store' do
      subject{ ->{ get_access_tokens } }
      before{ Fortnox::API.configure{ |conf| conf.token_store = { default: [access_token] } } }
      let( :repository ){ described_class.new( Model::Test, token_store: token_store ) }
      let(:token_store){ :non_existing_store }

      it{ is_expected.to raise_error( error, /#{token_store_not_present}/ ) }
    end

    context 'with no tokens set' do
      subject{ ->{ get_access_tokens } }
      before{ Fortnox::API.configure{ |conf| conf.token_store = {} } }
      let(:token_store){ :default }

      it{ is_expected.to raise_error( error, /#{token_store_not_present}/) }
    end

    context 'with one access token in token store' do
      before{ Fortnox::API.configure{ |conf| conf.token_store = { default: [access_token] } } }
      let(:token_store){ :default }
      it{ is_expected.to eql( [access_token] ) }
    end

    context 'with multiple access tokens in token store' do
      before do
        Fortnox::API.configure do |conf|
          conf.token_store = { default: [access_token, access_token2] }
        end
      end
      let( :token_store ){ :default }
      it{ is_expected.to eql( [access_token, access_token2] ) }
    end
  end

  describe '#check_access_tokens!' do
    subject{ ->{ repository.check_access_tokens!(tokens) } }
    before{ Fortnox::API.configure{ |conf| conf.client_secret = client_secret } }
    let(:error){ Fortnox::API::MissingConfiguration }
    let(:message){ 'not provided any access token' }

    context 'with nil' do
      let(:tokens){ nil }
      it{ is_expected.to raise_error(error, /#{message}/) }
    end

    context 'with empty array' do
      let(:tokens){ [] }
      it{ is_expected.to raise_error(error, /#{message}/) }
    end

    context 'with valied tokens' do
      let(:tokens){ ['12345', 'abcde'] }
      it{ is_expected.not_to raise_error }
    end
  end

  context 'making a request including the proper headers' do
    before do
      Fortnox::API.configure do |conf|
        conf.client_secret = client_secret
        conf.token_store = { default: access_token }
      end

      stub_request(
        :get,
        'https://api.fortnox.se/3/test',
      ).with(
        headers: headers
      ).to_return(
        status: 200
      )
    end

    subject{ repository.get( '/test', { body: '' } ) }

    it{ is_expected.to be_nil }
  end

  describe 'making requests with multiple access tokens' do
    before do
      Fortnox::API.configure do |conf|
        conf.client_secret = client_secret
        conf.token_store = { default: [access_token, access_token2] }
      end

      stub_request(
        :get,
        'https://api.fortnox.se/3/test',
      ).with(
        headers: {
          'Access-Token' => access_token,
          'Client-Secret' => client_secret,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 200,
        body: '1'
      )

      stub_request(
        :get,
        'https://api.fortnox.se/3/test',
      ).with(
        headers: {
          'Access-Token' => access_token2,
          'Client-Secret' => client_secret,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 200,
        body: '2'
      )
    end

    context 'with subsequent requests on same object' do
      let!(:response1){ repository.get( '/test', { body: '' } ) }
      let!(:response2){ repository.get( '/test', { body: '' } ) }
      let!(:response3){ repository.get( '/test', { body: '' } ) }

      # rubocop:disable RSpec/MultipleExpectations
      # All these checks must be run in same it-statement because
      # of the random starting index.
      it 'works' do
        expect(response1).not_to eq( response2 )
        expect(response1).to eq( response3 )
        expect(response3).not_to eq( response2 )
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  context 'raising error from remote server' do
    before do
      Fortnox::API.configure do |conf|
        conf.client_secret = client_secret
        conf.token_store = { default: [access_token, access_token2] }
      end

      stub_request(
        :post,
        'https://api.fortnox.se/3/test',
      ).to_return(
        status: 500,
        body: { 'ErrorInformation' => { 'error' => 1, 'message' => 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' } }.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )
    end

    subject{ ->{ repository.post( '/test', { body: '' } ) } }

    it{ is_expected.to raise_error( Fortnox::API::RemoteServerError ) }
    it{ is_expected.to raise_error( 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' ) }

    context 'with debugging enabled' do
      around do |example|
        Fortnox::API.config.debugging = true
        example.run
        Fortnox::API.config.debugging = false
      end

      it{ is_expected.to raise_error( /\<HTTParty\:\:Request\:0x/ ) }
    end
  end
end
