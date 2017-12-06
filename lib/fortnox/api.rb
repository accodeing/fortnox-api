require "set"
require "dry-struct"
require "fortnox/api/circular_queue"
require "fortnox/api/version"
require 'logger'

module Fortnox
  module API

    extend Dry::Configurable

    DEFAULT_CONFIGURATION = {
      base_url: 'https://api.fortnox.se/3/',
      client_secret: nil,
      access_tokens: nil,
      debugging: false,
      logger: ->{
        logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
        return logger
      }.call,
    }.freeze

    setting :base_url, DEFAULT_CONFIGURATION[:base_url]
    setting :client_secret, DEFAULT_CONFIGURATION[:client_secret]
    setting :access_tokens, DEFAULT_CONFIGURATION[:access_tokens]
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

require "fortnox/api/models"
require "fortnox/api/repositories"
require "fortnox/api/mappers"
