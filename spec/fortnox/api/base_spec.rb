require 'spec_helper'

describe Fortnox::API do

  describe 'creation' do
    context 'without parameters' do
      it 'fails when given as argument' do
        expect{
          Fortnox::API.new()
        }.to raise_error(
          ArgumentError,
          /base url/
        )
      end
    end

    context 'with only client_secret' do
      it 'fails when given as argument' do
        expect{
          Fortnox::API.new(
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
          Fortnox::API.new()
        }.to raise_error(
          ArgumentError,
          /client secret/
        )
      end
    end

    context 'with both base url and client secret' do
      it 'fails when given as argument' do
        expect{
          Fortnox::API.new(
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
          Fortnox::API.new()
        }.to raise_error(
          ArgumentError,
          /base url/
        )
      end
    end

  end

  context 'get access token' do
    it 'works' do
      stub_request(
        :get,
        'http://api.fortnox.se/3/',
      ).with(
        headers: {
          'Authorisation-Code' => 'ea3862b0-189c-464b-8e23-1b9702365ea1',
          'Client-Secret' => 'P5K5vE3Kun',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 200,
        body: { 'Authorisation' => { 'AccessToken' => '3f08d038-f380-4893-94a0-a08f6e60e67a' }}.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )

      response = Fortnox::API.get_access_token(
        base_url: 'http://api.fortnox.se/3/',
        client_secret: 'P5K5vE3Kun',
        authorization_code: 'ea3862b0-189c-464b-8e23-1b9702365ea1',
      )

      response.should == "3f08d038-f380-4893-94a0-a08f6e60e67a"
    end
  end

end