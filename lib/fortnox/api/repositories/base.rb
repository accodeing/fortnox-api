# frozen_string_literal: true

require 'httparty'
require 'jwt'
require 'base64'

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

        def initialize(keys_filtered_on_save: [:url])
          @keys_filtered_on_save = keys_filtered_on_save
          @mapper = Registry[Mapper::Base.canonical_name_sym(self.class::MODEL)].new
          return unless access_token.nil?

          raise MissingAccessToken,
                'No Access Token provided! You need to provide an Access Token: ' \
                'Fortnox::API.access_token = token'
        end

        private

        def access_token
          Fortnox::API.access_token
        end

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

        def config
          Fortnox::API.config
        end
      end
    end
  end
end
