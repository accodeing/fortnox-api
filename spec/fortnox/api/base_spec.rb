require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API::Base do

  describe 'creation' do
    context 'without parameters' do
      it 'fails when given as argument' do
        expect{
          Fortnox::API::Base.new()
        }.to raise_error(
          ArgumentError,
          /base url/
        )
      end
    end

    context 'with only client_secret' do
      it 'fails when given as argument' do
        expect{
          Fortnox::API::Base.new(
            base_url: ''
          )
        }.to raise_error(
          ArgumentError,
          /client secret/
        )
      end

      it 'fails when given as ENV' do
        stub_const('ENV', ENV.to_hash.merge('FORTNOX_API_BASE_URL' => 'xxx'))
        expect{
          Fortnox::API::Base.new()
        }.to raise_error(
          ArgumentError,
          /client secret/
        )
      end
    end

    context 'with both base url and client secret' do
      it 'fails when given as argument' do
        expect{
          Fortnox::API::Base.new(
            base_url: '',
            client_secret: '',
          )
        }.to raise_error(
          ArgumentError,
          /access token/
        )
      end

      it 'fails when given as ENV' do
        stub_const('ENV', ENV.to_hash.merge('FORTNOX_API_CLIENT_SECRET' => 'xxx', 'FORTNOX_API_ACCESS_TOKEN' => 'xxx'))
        expect{
          Fortnox::API::Base.new()
        }.to raise_error(
          ArgumentError,
          /base url/
        )
      end
    end

  end

  context 'raising error from remote server' do

    before{
      ENV['FORTNOX_API_BASE_URL'] = 'http://api.fortnox.se/3'
      ENV['FORTNOX_API_CLIENT_SECRET'] = 'P5K5vE3Kun'
      ENV['FORTNOX_API_ACCESS_TOKEN'] = '3f08d038-f380-4893-94a0-a08f6e60e67a'

      stub_request(
        :post,
        'http://api.fortnox.se/3/test',
      ).with(
        headers: {
          'Access-Token' => '3f08d038-f380-4893-94a0-a08f6e60e67a',
          'Client-Secret' => 'P5K5vE3Kun',
          'Content-Type'=>'application/json',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 500,
        body: { 'ErrorInformation': { 'error':1, 'message': 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' }}.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )
    }

    after{
      ENV['FORTNOX_API_BASE_URL'] = nil
      ENV['FORTNOX_API_CLIENT_SECRET'] = nil
      ENV['FORTNOX_API_ACCESS_TOKEN'] = nil
    }

    it 'raises a descriptive exception' do
      expect{ Fortnox::API::Base.new.post( '/test', { body: {}.to_json })}.to raise_error( Fortnox::API::RemoteServerError )
    end

    it 'preserves the original error message' do
      expect{ Fortnox::API::Base.new.post( '/test', { body: {}.to_json })}.to raise_error( 'Räkenskapsår finns inte upplagt. För att kunna skapa en faktura krävs det att det finns ett räkenskapsår' )
    end

    context 'with debugging enabled' do

      after{
        Fortnox::API.debugging = false
      }

      it 'includes the HTTParty request object to aid in debugging' do
        Fortnox::API.debugging = true
        expect{ Fortnox::API::Base.new.post( '/test', { body: {}.to_json })}.to raise_error( /\<HTTParty\:\:Request\:0x/ )
      end
    end
  end

end
