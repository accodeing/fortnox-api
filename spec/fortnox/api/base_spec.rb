require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API::Base do
  include Helpers::Environment

  before do
    # Class variable need to be reset before each test
    # since we are changing environment variables
    Fortnox::API::EnvironmentValidation::CircularQueue.class_variable_set(
      :@@next_index, 0
    )
  end

  describe 'creation' do
    before do
      stub_environment('FORTNOX_API_BASE_URL' => nil,
                       'FORTNOX_API_CLIENT_SECRET' => nil,
                       'FORTNOX_API_ACCESS_TOKEN' => nil)
    end

    subject{ ->{ described_class.new() } }

    context 'without FORTNOX_API_BASE_URL' do
      before do
        stub_environment('FORTNOX_API_BASE_URL' => nil)
      end

      it{ is_expected.to raise_error( ArgumentError, /base url/ ) }
    end

    context 'without FORTNOX_API_CLIENT_SECRET' do
      before do
        stub_environment('FORTNOX_API_BASE_URL' => 'xxx')
      end

      it{ is_expected.to raise_error( ArgumentError, /client secret/ ) }
    end

    context 'without FORTNOX_API_ACCESS_TOKEN' do
      before do
        stub_environment('FORTNOX_API_BASE_URL' => 'xxx',
                         'FORTNOX_API_CLIENT_SECRET' => 'xxx')
      end

      it{ is_expected.to raise_error( ArgumentError, /access token/ ) }
    end

  end

  context 'making a request including the proper headers' do
    before do
      stub_environment(
        'FORTNOX_API_BASE_URL' => 'http://api.fortnox.se/3',
        'FORTNOX_API_CLIENT_SECRET' => 'P5K5vE3Kun',
        'FORTNOX_API_ACCESS_TOKEN' => '3f08d038-f380-4893-94a0-a08f6e60e67a'
      )

      stub_request(
        :get,
        'http://api.fortnox.se/3/test',
      ).with(
        headers: {
          'Access-Token' => '3f08d038-f380-4893-94a0-a08f6e60e67a',
          'Client-Secret' => 'P5K5vE3Kun',
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 200
      )
    end

    subject{ described_class.new.get( '/test', { body: '' }) }

    it{ is_expected.to be_nil }
  end

  describe 'making requests with multiple access tokens' do

    before do
      stub_environment(
        'FORTNOX_API_BASE_URL' => 'http://api.fortnox.se/3',
        'FORTNOX_API_CLIENT_SECRET' => 'P5K5vE3Kun',
        'FORTNOX_API_ACCESS_TOKEN' => '3f08d038-f380-4893-94a0-a08f6e60e67a,aaee8217-0bbd-2e16-441f-668931d582cd'
      )

      stub_request(
        :get,
        'http://api.fortnox.se/3/test',
      ).with(
        headers: {
          'Access-Token' => '3f08d038-f380-4893-94a0-a08f6e60e67a',
          'Client-Secret' => 'P5K5vE3Kun',
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 200,
        body: '1'
      )

      stub_request(
        :get,
        'http://api.fortnox.se/3/test',
      ).with(
        headers: {
          'Access-Token' => 'aaee8217-0bbd-2e16-441f-668931d582cd',
          'Client-Secret' => 'P5K5vE3Kun',
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 200,
        body: '2'
      )
    end

    let!(:response1) { api.get( '/test', body: '' ) }
    let!(:response2) { api.get( '/test', body: '' ) }
    let!(:response3) { api.get( '/test', body: '' ) }

    let(:api){ described_class.new }

    it 'works'do
      expect(response1).not_to eq( response2 )
      expect(response1).to eq( response3 )
      expect(response3).not_to eq( response2 )
    end
  end

  context 'token rotation' do
    let(:customers_dummy_request) { described_class.new.get( '/customers', body: '' ) }
    let(:invoices_dummy_request) { described_class.new.get( '/orders', body: '' ) }
    let(:orders_dummy_request) { described_class.new.get( '/invoices', body: '' ) }

    def next_index
      Fortnox::API::EnvironmentValidation::CircularQueue.class_variable_get('@@next_index')
    end

    it 'is make at class leven (not instance level)' do
      expect(next_index).to be 0
      VCR.use_cassette( "#{ 'dummies' }/customers" ) { customers_dummy_request }
      expect(next_index).to be 1
      VCR.use_cassette( "#{ 'dummies' }/orders" ) { orders_dummy_request }
      expect(next_index).to be 0
      VCR.use_cassette( "#{ 'dummies' }/invoices" ) { invoices_dummy_request }
      expect(next_index).to be 1
    end
  end

  context 'raising error from remote server' do

    before do
      stub_environment(
        'FORTNOX_API_BASE_URL' => 'http://api.fortnox.se/3',
        'FORTNOX_API_CLIENT_SECRET' => 'P5K5vE3Kun',
        'FORTNOX_API_ACCESS_TOKEN' => '3f08d038-f380-4893-94a0-a08f6e60e67a'
      )

      stub_request(
        :post,
        'http://api.fortnox.se/3/test',
      ).to_return(
        status: 500,
        body: { 'ErrorInformation' => { 'error' => 1, 'message' => 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' } }.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )
    end

    subject{ ->{ described_class.new.post( '/test', { body: '' }) } }

    it{ is_expected.to raise_error( Fortnox::API::RemoteServerError ) }
    it{ is_expected.to raise_error( 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' ) }

    context 'with debugging enabled' do

      around do |example|
        Fortnox::API.debugging = true
        example.run
        Fortnox::API.debugging = false
      end

      it{ is_expected.to raise_error( /\<HTTParty\:\:Request\:0x/ ) }

    end
  end

end
