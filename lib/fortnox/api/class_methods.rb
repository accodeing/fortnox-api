module Fortnox
  module API
    module ClassMethods

      def get_access_token( base_url: nil, client_secret: nil, authorization_code: nil )
        repository = self.new(
          base_url: base_url,
          client_secret: client_secret,
          access_token: authorization_code,
        )

        repository.headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorisation-Code' => authorization_code,
          'Client-Secret' => client_secret,
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
