module Fortnox
  module API
    module ClassMethods

      def get_access_token( base_url: base_url, client_secret: client_secret, authorization_code: authorization_code )
        base_url = validate_base_url( base_url )
        client_secret = validate_client_secret( client_secret )
        authorization_code = validate_authorization_code( authorization_code )

        base_uri( base_url )

        set_headers(
          'Accept' => 'application/json',
          'Client-Secret' => client_secret,
          'Authorisation-Code' => authorization_code,
        )

        response = get('/').parsed_response
        response[ 'Authorisation' ][ 'AccessToken' ]
      end

      def set_header( name: name, value: value )
        headers[ name ] = value
      end

      def set_headers( headers = {} )
        headers.each do |name, value|
          set_header( name: name, value: value )
        end
      end

      def remove_header( name: name )
        headers.delete( name )
      end

      def validate_base_url( base_url )
        base_url ||= ENV['FORTNOX_API_BASE_URL']
        fail ArgumentError, 'You have to provide a base url.' unless base_url
        base_url
      end

      def validate_client_secret( client_secret )
        client_secret ||= ENV['FORTNOX_API_CLIENT_SECRET']
        fail ArgumentError, 'You have to provide your client secret.' unless client_secret
        client_secret
      end

      def validate_access_token( access_token )
        access_token ||= ENV['FORTNOX_API_ACCESS_TOKEN']
        fail ArgumentError, 'You have to provide your access token.' unless access_token
        access_token
      end

      def validate_authorization_code( authorization_code )
        authorization_code ||= ENV['FORTNOX_API_AUTHORIZATION_CODE']
        fail ArgumentError, 'You have to provide your access token.' unless authorization_code
        authorization_code
      end

    end
  end
end