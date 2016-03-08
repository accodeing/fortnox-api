require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API do

  context 'get access token' do
    before do
      ENV['FORTNOX_API_BASE_URL'] = 'http://api.fortnox.se/3/'
      ENV['FORTNOX_API_CLIENT_SECRET'] = 'P5K5vE3Kun'
      ENV['FORTNOX_API_ACCESS_TOKEN'] = '3f08d038-f380-4893-94a0-a08f6e60e67a'
      ENV['FORTNOX_API_AUTHORIZATION_CODE'] = 'ea3862b0-189c-464b-8e23-1b9702365ea1'
    end

    it 'works' do
      stub_request(
        :get,
        'http://api.fortnox.se/3/',
      ).with(
        headers: {
          'Authorization-Code' => 'ea3862b0-189c-464b-8e23-1b9702365ea1',
          'Client-Secret' => 'P5K5vE3Kun',
          'Accept' => 'application/json',
        }
      ).to_return(
        status: 200,
        body: { 'Authorisation' => { 'AccessToken' => '3f08d038-f380-4893-94a0-a08f6e60e67a' } }.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )

      response = Fortnox::API.get_access_token

      expect( response).to eql( "3f08d038-f380-4893-94a0-a08f6e60e67a" )
    end
  end

end
