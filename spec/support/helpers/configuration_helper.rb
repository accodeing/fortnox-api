# frozen_string_literal: true

require 'dotenv'
require 'jwt'

DOTENV_FILE_NAME = '.env.test'
Dotenv.load(DOTENV_FILE_NAME)

DEBUG = ENV.fetch('DEBUG', false)

class TokenStore
  def access_token
    ENV.fetch('FORTNOX_API_ACCESS_TOKEN')
  end

  def refresh_token
    raise StandardError,
          'Something went wrong, #refresh_token should not be called during this test. ' \
          'Verify that the access token is valid.'
  end

  def access_token=(token)
    raise StandardError,
          'Something went wrong, #access_token= should not be called during this test. ' \
          'Verify that the access token is valid.'
  end

  def refresh_token=(token)
    raise StandardError,
          'Something went wrong, #refresh_token= should not be called during this test. ' \
          'Verify that the access token is valid.'
  end
end

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
