require 'fortnox/api/base'

module Fortnox
  module API
    class AccessToken < Base

      def self.get( client_secret:, authorization_code: )
        repository = self.new

        repository.headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorization-Code' => authorization_code,
          'Client-Secret' => client_secret,
        }

        response = repository.get('/')

        response[ 'Authorisation' ][ 'AccessToken' ]
      end

    end
  end
end
