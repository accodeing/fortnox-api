require "fortnox/api/class_methods"
require "httparty"

module Fortnox
  module API
    class Base

      include HTTParty
      extend Forwardable
      extend Fortnox::API::ClassMethods

      HTTParty::Parser::SupportedFormats["text/html"] = :json

      def_delegators self, :set_header, :set_headers, :remove_header,
        :remove_headers, :validate_base_url, :validate_client_secret,
        :validate_response, :validate_access_token, :validate_authorization_code

      def initialize( base_url: nil, client_secret: nil, access_token: nil )
        base_url = validate_base_url( base_url )
        client_secret = validate_client_secret( client_secret )
        access_token = validate_access_token( access_token )

        self.class.base_uri( base_url )

        set_headers(
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Client-Secret' => client_secret,
          'Access-Token' => access_token,
        )
      end

      def get( *args )
        validate_and_parse_response self.class.get( *args )
      end

      def put( *args )
        validate_and_parse_response self.class.put( *args )
      end

      def post( *args )
        validate_and_parse_response self.class.post( *args )
      end

      def delete( *args )
        validate_and_parse_response self.class.delete( *args )
      end

    private

      def validate_and_parse_response( response )
        validate_response( response )
        response.parsed_response
      end

    end
  end
end
