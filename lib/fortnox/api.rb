# frozen_string_literal: true

require 'set'
require 'dry-configurable'
require 'dry-container'
require 'logger'

require_relative 'api/version'

module Fortnox
  module API
    extend Dry::Configurable

    DEFAULT_CONFIGURATION = {
      base_url: 'https://api.fortnox.se/3/',
      token_url: 'https://apps.fortnox.se/oauth-v1/token',
      debugging: false,
      logger: lambda {
        logger = Logger.new($stdout)
        logger.level = Logger::WARN
        return logger
      }.call
    }.freeze

    setting :base_url, default: DEFAULT_CONFIGURATION[:base_url]
    setting :token_url, default: DEFAULT_CONFIGURATION[:token_url]
    setting :debugging, default: DEFAULT_CONFIGURATION[:debugging], reader: true
    setting :logger, default: DEFAULT_CONFIGURATION[:logger], reader: true

    def self.access_token=(token)
      Thread.current[:access_token] = token
    end

    def self.access_token
      Thread.current[:access_token]
    end

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

    class MissingAccessToken < Fortnox::API::Exception
    end

    Registry = Dry::Container.new
  end
end

require_relative 'api/models'
require_relative 'api/repositories'
require_relative 'api/mappers'
