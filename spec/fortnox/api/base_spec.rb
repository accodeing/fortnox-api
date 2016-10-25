require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API::Base do

  describe 'creation' do
    before do
      stub_const('ENV', ENV.to_hash.merge('FORTNOX_API_BASE_URL' => nil,
                                         'FORTNOX_API_CLIENT_SECRET' => nil,
                                         'FORTNOX_API_ACCESS_TOKEN' => nil))
    end

    subject{ ->{ described_class.new() } }

    context 'without FORTNOX_API_BASE_URL' do
      before do
        stub_const('ENV', ENV.to_hash.merge('FORTNOX_API_BASE_URL' => nil))
      end

      it{ is_expected.to raise_error( ArgumentError, /base url/ ) }
    end

    context 'without FORTNOX_API_CLIENT_SECRET' do
      before do
        stub_const('ENV', ENV.to_hash.merge('FORTNOX_API_BASE_URL' => 'xxx'))
      end

      it{ is_expected.to raise_error( ArgumentError, /client secret/ ) }
    end

    context 'without FORTNOX_API_ACCESS_TOKEN' do
      before do
        stub_const('ENV', ENV.to_hash.merge('FORTNOX_API_BASE_URL' => 'xxx',
                                            'FORTNOX_API_CLIENT_SECRET' => 'xxx'))
      end

      it{ is_expected.to raise_error( ArgumentError, /access token/ ) }
    end

  end

  context 'making a request including the proper headers' do
    before do
      stub_const(
        'ENV', ENV.to_hash.merge(
          'FORTNOX_API_BASE_URL' => 'http://api.fortnox.se/3',
          'FORTNOX_API_CLIENT_SECRET' => 'P5K5vE3Kun',
          'FORTNOX_API_ACCESS_TOKEN' => '3f08d038-f380-4893-94a0-a08f6e60e67a'
        )
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
      stub_const(
        'ENV', ENV.to_hash.merge(
          'FORTNOX_API_BASE_URL' => 'http://api.fortnox.se/3',
          'FORTNOX_API_CLIENT_SECRET' => 'P5K5vE3Kun',
          'FORTNOX_API_ACCESS_TOKEN' => '3f08d038-f380-4893-94a0-a08f6e60e67a,aaee8217-0bbd-2e16-441f-668931d582cd'
        )
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

    let!(:api){ described_class.new }
    let!(:response1){ api.get( path, body: '' ) }
    let!(:response2){ api.get( path, body: '' ) }
    let!(:response3){ api.get( path, body: '' ) }

    let(:path){ '/test' }

    describe 'first request' do
      subject{ response1 }
      it{ is_expected.not_to eq( response2 ) }
      it{ is_expected.to eq( response3 ) }
    end

    describe 'third request' do
      subject{ response3 }
      it{ is_expected.not_to eq( response2 ) }
    end
  end

  context 'raising error from remote server' do

    before do
      stub_const(
        'ENV', ENV.to_hash.merge(
          'FORTNOX_API_BASE_URL' => 'http://api.fortnox.se/3',
          'FORTNOX_API_CLIENT_SECRET' => 'P5K5vE3Kun',
          'FORTNOX_API_ACCESS_TOKEN' => '3f08d038-f380-4893-94a0-a08f6e60e67a'
        )
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
