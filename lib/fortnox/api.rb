require "set"
require "dotenv"
require "dry-struct"
require "fortnox/api/configuration"
require "fortnox/api/circular_queue"
require "fortnox/api/base"
require "fortnox/api/version"
require 'logger'

Dotenv.load unless ENV['RUBY_ENV'] == 'test'

module Fortnox
  module API

    include Configuration.with(
      base_url: 'https://api.fortnox.se/3/',
      client_secret: nil,
      token_store: {},
      debugging: false,
      logger: ->{
        logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
        return logger
      }.call,
    )

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

    def check_access_tokens!( tokens )
      if tokens == nil or tokens.length.zero?
        fail MissingConfiguration, "You have not provided any access token(s) in the given store."
      end
    end

    def load_access_tokens( store_name )
      tokens = config.token_store[ store_name ]
      check_access_tokens!( tokens )
      tokens
    end

    def get_access_token( store_name )
      @access_tokens ||= CircularQueue.new( *load_access_tokens( store_name ))
      @access_tokens.next
    end

    def get_base_url
      base_url = config.base_url
      fail MissingConfiguration, 'You have to provide a base url.' unless base_url
      base_url
    end

    def get_client_secret
      client_secret = config.client_secret
      fail MissingConfiguration, 'You have to provide your client secret.' unless client_secret
      client_secret
    end

    def get_authorization_code
      authorization_code = config.authorization_code
      fail MissingConfiguration, 'You have to provide your authorization code.' unless authorization_code
      authorization_code
    end

    Registry = Dry::Container.new
  end
end

require "fortnox/api/models"
require "fortnox/api/repositories"
require "fortnox/api/mappers"
