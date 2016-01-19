require "fortnox/api/class_methods"
require "httparty"

module Fortnox
  module API
    class Base

      include HTTParty
      extend Forwardable
      extend Fortnox::API::ClassMethods

      def_delegators self, :set_header, :set_headers, :remove_header,
        :remove_headers, :validate_base_url, :validate_client_secret,
        :validate_response, :validate_access_token, :validate_authorization_code

      def initialize( base_url: nil, client_secret: nil, access_token: nil )
        base_url = validate_base_url( base_url )
        client_secret = validate_client_secret( client_secret )
        access_token = validate_access_token( access_token )

        self.class.base_uri( base_url )

        set_headers(
          'Accept' => 'application/json',
          'Client-Secret' => client_secret,
          'Access-Token' => access_token,
        )
      end

      def get( *args )
        response = self.class.get( *args )
        validate_response( response )
        response.parsed_response
      end

      def put( *args )
        response = self.class.get( *args )
        validate_response( response )
        response.parsed_response
      end

      def post( *args )
        response = self.class.get( *args )
        validate_response( response )
        response.parsed_response
      end

      def delete( *args )
        response = self.class.get( *args )
        validate_response( response )
        response.parsed_response
      end

    end
  end
end
