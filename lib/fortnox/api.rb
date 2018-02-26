# frozen_string_literal: true

require 'set'
require 'dry-struct'
require 'fortnox/api/circular_queue'
require 'fortnox/api/version'
require 'logger'

module Fortnox
  module API
    extend Dry::Configurable

    DEFAULT_CONFIGURATION = {
      base_url: 'https://api.fortnox.se/3/',
      client_secret: nil,
      token_store: {},
      access_token: nil,
      access_tokens: nil,
      debugging: false,
      logger: lambda {
        logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
        return logger
      }.call
    }.freeze

    setting :base_url, DEFAULT_CONFIGURATION[:base_url]
    setting :client_secret, DEFAULT_CONFIGURATION[:client_secret]
    setting :token_store, DEFAULT_CONFIGURATION[:token_store]
    setting :access_token, DEFAULT_CONFIGURATION[:access_token] do |value|
      next if value.nil? # nil is a valid unassigned value
      invalid_access_token_format!(value) unless value.is_a?(String)
      config.token_store = { default: value }
      value
    end
    setting :access_tokens, DEFAULT_CONFIGURATION[:access_tokens] do |value|
      next if value.nil? # nil is a valid unassigned value
      invalid_access_tokens_format!(value) unless value.is_a?(Hash) || value.is_a?(Array)
      config.token_store = value.is_a?(Hash) ? value : { default: value }
      value
    end
    setting :debugging, DEFAULT_CONFIGURATION[:debugging], reader: true
    setting :logger, DEFAULT_CONFIGURATION[:logger], reader: true

    class Exception < StandardError
    end

    class AttributeError < Fortnox::API::Exception
    end

    class RemoteServerError < Fortnox::API::Exception
    end

    class MissingAttributeError < Fortnox::API::Exception
    end

    class MissingConfiguration < Fortnox::API::Exception
    end

    Registry = Dry::Container.new

    def self.invalid_access_token_format!(value)
      raise ArgumentError,
            'expected a String, but '\
            "#{value.inspect} is a(n) #{value.class}"
    end
    private_class_method :invalid_access_token_format!

    def self.invalid_access_tokens_format!(value)
      raise ArgumentError,
            'expected a Hash or an Array, but '\
            "#{value.inspect} is a(n) #{value.class}"
    end
    private_class_method :invalid_access_tokens_format!
  end
end

require 'fortnox/api/models'
require 'fortnox/api/repositories'
require 'fortnox/api/mappers'
