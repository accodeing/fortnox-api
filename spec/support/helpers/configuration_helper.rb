# frozen_string_literal: true

require 'dotenv'
require 'jwt'

DOTENV_FILE_NAME = '.env.test'
Dotenv.load(DOTENV_FILE_NAME)

DEBUG = ENV.fetch('DEBUG', false)

module Helpers
  module Configuration
    def set_api_test_configuration
      Fortnox::API.configure do |config|
        config.debugging = DEBUG

        if DEBUG
          config.logger = lambda {
            logger = Logger.new($stdout)
            logger.level = Logger::DEBUG
            return logger
          }.call
        end
      end

      Fortnox::API.access_token = 'a_test_token'
    end
  end
end
