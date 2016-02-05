require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API do

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
        body: { 'Authorisation' => { 'AccessToken' => '3f08d038-f380-4893-94a0-a08f6e60e67a' } }.to_json,
        headers: { 'Content-Type' => 'application/json' },
      )

      response = Fortnox::API.get_access_token(
        base_url: 'http://api.fortnox.se/3/',
        client_secret: 'P5K5vE3Kun',
        authorization_code: 'ea3862b0-189c-464b-8e23-1b9702365ea1',
      )

      expect( response).to eql( "3f08d038-f380-4893-94a0-a08f6e60e67a" )
    end
  end

end
