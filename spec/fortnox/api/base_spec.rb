require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API::Base do
  let(:access_token){ '3f08d038-f380-4893-94a0-a08f6e60e67a' }
  let(:access_token2){ '89feajou-sif8-8f8u-29ja-xdfniokeniod' }
  let(:client_secret){ 'P5K5vE3Kun' }
  let(:base){ described_class.new }
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
    subject{ ->{ described_class.new() } }

    context 'without base url' do
      before{ Fortnox::API.configure{ |conf| conf.base_url = nil } }
      let(:error){ Fortnox::API::MissingConfiguration }
      let(:message){ 'have to provide a base url' }

      it{ is_expected.to raise_error( error, /#{message}/ ) }
    end

    context 'without client secret' do
      before{ Fortnox::API.configure{ |conf| conf.client_secret = nil } }
      let(:error){ Fortnox::API::MissingConfiguration }
      let(:message){ 'have to provide your client secret' }

      it{ is_expected.to raise_error( error, /#{message}/ ) }
    end
  end

  describe '.get_access_token' do
    before{ Fortnox::API.configure{ |conf| conf.client_secret = client_secret } }

    context 'with one access token' do
      subject{ base.get_access_token(:default) }
      before{ Fortnox::API.configure{ |conf| conf.token_store = { default: [access_token] } } }
      it{ is_expected.to eql( access_token ) }
    end

    context 'with multiple access tokens' do
      subject{ access_tokens }
      before{ Fortnox::API.configure{ |conf| conf.token_store = { default: access_tokens } } }
      let(:access_tokens){ [access_token, access_token2] }

      it{ is_expected.to include(base.get_access_token(:default)) }

      # rubocop:disable RSpec/MultipleExpectations
      # All these checks must be run in same it-statement because
      # of the random starting index.
      it 'circulates the tokens' do
        token1 = base.get_access_token(:default)
        token2 = base.get_access_token(:default)
        token3 = base.get_access_token(:default)

        expect(token1).to eql(token3)
        expect(token1).not_to eql(token2)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'without token store (just access token)' do
      it 'should be tested'
    end

    context 'with multiple stores' do
      subject{ base.get_access_token(token_store) }
      before do 
        Fortnox::API.configure do |config|
          config.token_store = { store1: access_token, store2: access_token2 }
        end
      end

      describe 'first token store' do
        let(:token_store){ :store1 }
        it{ is_expected.to eql access_token }
      end

      describe 'second token store' do
        let(:token_store){ :store2 }
        it{ is_expected.to eql access_token2 }
      end
    end
  end

  describe '.load_acces_tokens' do
    subject(:load_access_tokens){ base.load_access_tokens(store_name) }

    before do
      Fortnox::API.configure do |conf|
        conf.token_store = { default: [access_token] }
        conf.client_secret = client_secret
      end
    end

    let(:store_name_not_present){ "#{store_name} is not present in token store" }
    let(:error){ Fortnox::API::MissingConfiguration }

    context 'with non existing token store' do
      subject{ ->{ load_access_tokens } }
      let(:store_name){ :non_existing_store }

      it{ is_expected.to raise_error( error, /#{store_name_not_present}/ ) }
    end

    context 'with no tokens set' do
      subject{ ->{ load_access_tokens } }
      before{ Fortnox::API.configure{ |conf| conf.token_store = {} } }
      let(:store_name){ :whatever }

      it{ is_expected.to raise_error( error, /#{store_name_not_present}/) }
    end

    context 'with one access token in token store' do
      let(:store_name){ :default }
      it{ is_expected.to eql( [access_token] ) }
    end

    context 'with multiple access tokens in token store'
  end

  describe 'check_access_tokens!' do
    subject{ ->{ base.check_access_tokens!(tokens) } }
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

  describe '.get_base_url' do
    before{ Fortnox::API.configure{ |conf| conf.client_secret = client_secret } }

    context 'without setting any base_url' do
      subject{ base.get_base_url }
      it{ is_expected.to eql( 'https://api.fortnox.se/3/' ) }
    end

    context 'when setting to nil' do
      before{ Fortnox::API.configure{ |conf| conf.base_url = nil } }
      subject{ ->{ base.get_base_url } }
      let(:msg){ 'have to provide a base url' }

      it{ is_expected.to raise_error( Fortnox::API::MissingConfiguration, /#{msg}/ ) }
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

    subject{ described_class.new.get( '/test', { body: '' }, token_store: :default ) }

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
      let!(:response1){ api.get( '/test', { body: '' }, token_store: :default ) }
      let!(:response2){ api.get( '/test', { body: '' }, token_store: :default ) }
      let!(:response3){ api.get( '/test', { body: '' }, token_store: :default ) }

      let(:api){ described_class.new }

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

    subject{ ->{ described_class.new.post( '/test', { body: '' }, token_store: :default ) } }

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
