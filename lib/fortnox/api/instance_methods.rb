module Fortnox
  module API
    module InstanceMethods

      def initialize( base_url: base_url, client_secret: client_secret, access_token: access_token )
        base_url = validate_base_url( base_url )
        client_secret = validate_client_secret( client_secret )
        access_token = validate_access_token( access_token )

        base_uri( base_url )

        set_headers(
          'Accept' => 'application/json',
          'Client-Secret' => client_secret,
          'Access-Token' => access_token,
        )
      end

      def set_header( name: name, value: value )
        self.class.set_header( name: name, value: value )
      end

      def set_headers( headers )
        self.class.set_headers( headers )
      end

      def remove_header( name: name )
        self.class.remove_header( name: name )
      end

      def remove_headers( *headers )
        headers.each do |name|
          remove_header( name: name )
        end
      end

    private

      def validate_base_url( base_url )
        self.class.validate_base_url( base_url )
      end

      def validate_client_secret( client_secret )
        self.class.validate_client_secret( client_secret )
      end

      def validate_access_token( access_token )
        self.class.validate_access_token( access_token )
      end

      def validate_authorization_code( authorization_code )
        self.class.validate_authorization_code( authorization_code )
      end

    end
  end
end