# frozen_string_literal: true

require 'httparty'
require 'jwt'
require 'base64'

require_relative 'base/loaders'
require_relative 'base/savers'
require_relative '../request_handling'

# TODO: Temporarily disables metrics since this will be rewritten soon...
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
module Fortnox
  module API
    module Repository
      class Base
        include HTTParty
        include Fortnox::API::RequestHandling
        include Loaders
        include Savers

        TIME_MARGIN_FOR_ACCESS_TOKEN_RENEWAL = 5 * 60 # 5 minutes
        private_constant :TIME_MARGIN_FOR_ACCESS_TOKEN_RENEWAL

        HTTParty::Parser::SupportedFormats['text/html'] = :json

        headers(
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        )

        HTTP_METHODS = %i[get put post delete].freeze

        attr_accessor :headers
        attr_reader :mapper, :keys_filtered_on_save

        def self.set_headers(headers = {})
          self.headers.merge!(headers)
        end

        HTTP_METHODS.each do |method|
          define_method method do |path, options = {}, &block|
            provided_headers = options[:headers] || {}
            provided_headers['Authorization'] = "Bearer #{access_token}"
            options[:headers] = provided_headers
            options[:base_uri] ||= base_url
            execute do |remote|
              remote.send(method, path, options, &block)
            end
          end
        end

        def initialize(keys_filtered_on_save: [:url], token_store: :default)
          @keys_filtered_on_save = keys_filtered_on_save
          @mapper = Registry[Mapper::Base.canonical_name_sym(self.class::MODEL)].new
          @token_store_name = token_store
          @token_store = config.token_stores.fetch(token_store.to_sym) do |key|
            raise MissingConfiguration,
                  "There is no token store named \"#{key}\". " \
                  "Available token stores: #{config.token_stores}."
          end
        end

        def access_token
          token = @token_store.access_token

          if token.nil? || token.empty? || expired?(token)
            renew_access_token
            return @token_store.access_token
          end

          token
        end

        private

        def instantiate(hash)
          hash[:new] = false
          hash[:unsaved] = false
          self.class::MODEL.new(hash)
        end

        def base_url
          base_url = config.base_url
          raise MissingConfiguration, 'You have to provide a base url.' unless base_url

          base_url
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

        def expired?(token)
          decoded_token = JWT.decode token, nil, false

          # Token gets expired when it's smaller than current time.
          # The greater the current time is, the more "expired" the token will get,
          # so the expiration token needs to be smaller than the time now
          # plus some time margin.
          decoded_token[0]['exp'] < (Time.now.to_i + TIME_MARGIN_FOR_ACCESS_TOKEN_RENEWAL)
        rescue JWT::DecodeError
          raise Exception, "Could not decode access token for token store \"#{@token_store_name}\""
        end

        def renew_access_token
          refresh_token = @token_store.refresh_token

          if refresh_token.nil? || refresh_token.empty?
            raise MissingConfiguration,
                  "Refresh token for store \"#{@token_store_name}\" is empty!"
          end

          credentials = Base64.encode64("#{client_id}:#{client_secret}")

          renew_headers = {
            'Content-type' => 'application/x-www-form-urlencoded',
            Authorization: "Basic #{credentials}"
          }

          body = {
            grant_type: 'refresh_token',
            refresh_token: @token_store.refresh_token
          }

          if Fortnox::API.debugging
            logger.log('Renewing token')
            logger.log("Token url: #{config.token_url}")
            logger.log("Headers: #{renew_headers}")
            logger.log("Body: #{body}")
          end

          response = HTTParty.post(config.token_url, headers: renew_headers, body: body)

          if response.code != 200
            message = 'Unable to renew access token. ' \
                      "Response code: #{response.code}. " \
                      "Response message: #{response.message}. " \
                      "Response body: #{response.body}"

            raise Exception, message
          end

          new_access_token = response.parsed_response['access_token']
          new_refresh_token = response.parsed_response['refresh_token']
          @token_store.access_token = new_access_token
          @token_store.refresh_token = new_refresh_token
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
