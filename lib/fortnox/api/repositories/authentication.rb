# frozen_string_literal: true

require_relative 'base'

module Fortnox
  module API
    module Repository
      class Authentication
        def renew_tokens(refresh_token)
          raise ArgumentError, 'Refresh token is empty!' if refresh_token.nil? || refresh_token.empty?

          body = {
            grant_type: 'refresh_token',
            refresh_token: refresh_token
          }

          response = HTTParty.post(config.token_url,
                                   headers: headers(client_id, client_secret),
                                   body: body)

          validate_response(response)

          parsed_response_to_hash(response.parsed_response)
        end

        private

        def parsed_response_to_hash(parsed_response)
          {
            access_token: parsed_response['access_token'],
            refresh_token: parsed_response['refresh_token'],
            expires_in: parsed_response['expires_in'],
            token_type: parsed_response['token_type'],
            scope: parsed_response['scope']
          }
        end

        def headers(client_id, client_secret)
          credentials = Base64.encode64("#{client_id}:#{client_secret}")

          {
            'Content-type' => 'application/x-www-form-urlencoded',
            Authorization: "Basic #{credentials}"
          }
        end

        def validate_response(response)
          raise Fortnox::API::RemoteServerError, "Bad request. Error: \"#{response.body}\"" if response.code == 400

          if response.code == 401
            raise Fortnox::API::RemoteServerError, "Unauthorized request. Error: \"#{response.body}\""
          end

          return unless response.code != 200

          message = 'Unable to renew access token. ' \
                    "Response code: #{response.code}. " \
                    "Response message: #{response.message}. " \
                    "Response body: #{response.body}"

          raise Exception, message
        end

        def client_id
          client_id = config.client_id
          raise MissingConfiguration, 'You have to provide your client id.' unless client_id

          client_id
        end

        def client_secret
          client_secret = config.client_secret
          raise MissingConfiguration, 'You have to provide your client secret.' unless client_secret

          client_secret
        end

        def config
          Fortnox::API.config
        end
      end
    end
  end
end
