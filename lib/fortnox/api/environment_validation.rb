module Fortnox
  module API
    module EnvironmentValidation

      private

        def get_base_url
          base_url = ENV['FORTNOX_API_BASE_URL']
          fail ArgumentError, 'You have to provide a base url.' unless base_url
          base_url
        end

        def get_client_secret
          client_secret = ENV['FORTNOX_API_CLIENT_SECRET']
          fail ArgumentError, 'You have to provide your client secret.' unless client_secret
          client_secret
        end

        def get_access_token
          access_token = ENV['FORTNOX_API_ACCESS_TOKEN']
          fail ArgumentError, 'You have to provide your access token.' unless access_token
          access_token
        end

        def get_authorization_code
          authorization_code = ENV['FORTNOX_API_AUTHORIZATION_CODE']
          fail ArgumentError, 'You have to provide your access token.' unless authorization_code
          authorization_code
        end

    end
  end
end
