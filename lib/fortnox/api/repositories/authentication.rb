# frozen_string_literal: true

require_relative 'base'

module Fortnox
  module API
    module Repository
      class Authentication
        def renew_tokens(refresh_token:, client_id:, client_secret:)
          body = {
            grant_type: 'refresh_token',
            refresh_token: refresh_token
          }

          response = HTTParty.post(Fortnox::API.config.token_url,
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
          return if response.code == 200

          case response.code
          when 400
            raise Fortnox::API::RemoteServerError, "Bad request. Error: \"#{response.body}\""
          when 401
            raise Fortnox::API::RemoteServerError, "Unauthorized request. Error: \"#{response.body}\""
          else
            message = 'Unable to renew access token. ' \
                      "Response code: #{response.code}. " \
                      "Response message: #{response.message}. " \
                      "Response body: #{response.body}"
            raise Exception, message
          end
        end
      end
    end
  end
end
