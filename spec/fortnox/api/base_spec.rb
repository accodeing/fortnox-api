require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API::Base do

  describe 'creation' do

    subject{ ->{ Fortnox::API::Base.new() } }

    context 'without FORTNOX_API_BASE_URL' do
      before { ENV['FORTNOX_API_BASE_URL'] = nil }

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
      ENV['FORTNOX_API_BASE_URL'] = 'http://api.fortnox.se/3'
      ENV['FORTNOX_API_CLIENT_SECRET'] = 'P5K5vE3Kun'
      ENV['FORTNOX_API_ACCESS_TOKEN'] = '3f08d038-f380-4893-94a0-a08f6e60e67a'

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

    subject{ Fortnox::API::Base.new.get( '/test', { body: '' }) }

    it{ is_expected.to be_nil }
  end

  context 'raising error from remote server' do

    before do
      ENV['FORTNOX_API_BASE_URL'] = 'http://api.fortnox.se/3'
      ENV['FORTNOX_API_CLIENT_SECRET'] = 'P5K5vE3Kun'
      ENV['FORTNOX_API_ACCESS_TOKEN'] = '3f08d038-f380-4893-94a0-a08f6e60e67a'

      stub_request(
        :post,
        'http://api.fortnox.se/3/test',
      ).to_return(
        status: 500,
        body: { 'ErrorInformation' => { 'error' => 1, 'message' => 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' } }.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )
    end

    subject{ ->{ Fortnox::API::Base.new.post( '/test', { body: '' }) } }

    it{ is_expected.to raise_error( Fortnox::API::RemoteServerError ) }
    it{ is_expected.to raise_error( 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' ) }

    context 'with debugging enabled' do

      around(:each) do |example|
        Fortnox::API.debugging = true
        example.run
        Fortnox::API.debugging = false
      end

      it{ is_expected.to raise_error( /\<HTTParty\:\:Request\:0x/ ) }

    end
  end

end
