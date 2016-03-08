require 'fortnox/api/environment_validation'

module Fortnox
  module API
    module ClassMethods

      include Fortnox::API::EnvironmentValidation

      def get_access_token
        repository = self.new

        repository.headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorization-Code' => get_authorization_code,
          'Client-Secret' => get_client_secret,
        }

        response = repository.get('/')

        response[ 'Authorisation' ][ 'AccessToken' ]
      end

      def set_headers( headers = {} )
        self.headers.merge!( headers )
      end

    end
  end
end
