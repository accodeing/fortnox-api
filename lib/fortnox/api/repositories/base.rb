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

        def self.set_headers(headers = {}) # rubocop:disable Naming/AccessorMethodName
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
          @token_store_name = token_store
          @token_store = get_token_store(token_store)
          @mapper = Registry[Mapper::Base.canonical_name_sym(self.class::MODEL)].new
        end

        def access_token
          token = @token_store.access_token

          if token.nil? || token.empty? || expired?(token)
            return renew_access_token
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

        def get_token_store(name)
          store = config.token_stores&.dig(name.to_sym)
          validate_store(store, name)
        end

        def validate_store(store, name)
          if store.nil?
            raise MissingConfiguration,
                  "There is no token store named \"#{name}\". " \
                  "config.token_stores: #{config.token_stores}."
          end

          unless store.respond_to? :access_token
            raise MissingConfiguration,
                  "Store named #{name} does not implement required #access_token."
          end

          unless store.respond_to? :refresh_token
            raise MissingConfiguration,
                  "Store named #{name} does not implement required #refresh_token"
          end

          unless store.respond_to? :access_token=
            raise MissingConfiguration,
                  "Store named #{name} does not implement required #access_token="
          end

          unless store.respond_to? :refresh_token=
            raise MissingConfiguration,
                  "Store named #{name} does not implement required #refresh_token="
          end

          store
        end

        def expired?(token)
          decoded_token = JWT.decode token, nil, false
          decoded_token[0]['exp'] < (Time.now.to_i - TIME_MARGIN_FOR_ACCESS_TOKEN_RENEWAL)
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

          new_access_token
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
