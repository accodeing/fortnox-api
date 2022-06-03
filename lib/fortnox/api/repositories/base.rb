# frozen_string_literal: true

require 'httparty'

require_relative 'base/loaders'
require_relative 'base/savers'
require_relative '../request_handling'

module Fortnox
  module API
    module Repository
      class Base
        include HTTParty
        include Fortnox::API::RequestHandling
        include Loaders
        include Savers

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
            provided_headers['Client-Secret'] = client_secret
            provided_headers['Access-Token'] = next_access_token
            options[:headers] = provided_headers
            options[:base_uri] ||= base_url
            execute do |remote|
              remote.send(method, path, options, &block)
            end
          end
        end

        def initialize(keys_filtered_on_save: [:url], token_store: :default)
          @keys_filtered_on_save = keys_filtered_on_save
          @token_store = token_store
          @mapper = Registry[Mapper::Base.canonical_name_sym(self.class::MODEL)].new
        end

        def next_access_token
          @access_tokens ||= CircularQueue.new(*access_tokens)
          @access_tokens.next
        end

        def check_access_tokens!(tokens)
          tokens_present = !(tokens.nil? || tokens.empty?)
          return if tokens_present

          error_message = "You have not provided any access tokens in token store #{@token_store.inspect}."
          raise MissingConfiguration, error_message
        end

        def access_tokens
          begin
            tokens = config.token_store.fetch(@token_store)
          rescue KeyError
            token_store_not_found!(@token_store.inspect)
          end

          check_access_tokens!(tokens)
          tokens
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

        def client_secret
          client_secret = config.client_secret
          raise MissingConfiguration, 'You have to provide your client secret.' unless client_secret

          client_secret
        end

        def config
          Fortnox::API.config
        end

        def token_store_not_found!(store_name)
          raise MissingConfiguration,
                "There is no token store named #{store_name}. Available stores are #{config.token_store.keys}."
        end
      end
    end
  end
end
