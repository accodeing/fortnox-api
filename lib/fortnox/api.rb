# frozen_string_literal: true

require 'set'
require 'dry-struct'
require 'logger'

require_relative 'api/version'

module Fortnox
  module API
    extend Dry::Configurable

    DEFAULT_CONFIGURATION = {
      base_url: 'https://api.fortnox.se/3/',
      client_id: nil,
      client_secret: nil,
      token_stores: {},
      token_url: 'https://apps.fortnox.se/oauth-v1/token',
      debugging: false,
      logger: lambda {
        logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
        return logger
      }.call
    }.freeze

    setting :base_url, DEFAULT_CONFIGURATION[:base_url]
    setting :client_id, DEFAULT_CONFIGURATION[:client_id]
    setting :client_secret, DEFAULT_CONFIGURATION[:client_secret]
    setting :token_stores, DEFAULT_CONFIGURATION[:token_stores]
    setting :token_url, DEFAULT_CONFIGURATION[:token_url]
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
  end
end

require_relative 'api/models'
require_relative 'api/repositories'
require_relative 'api/mappers'
