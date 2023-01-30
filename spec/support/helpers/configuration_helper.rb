# frozen_string_literal: true

require 'dotenv'
require 'jwt'

DOTENV_FILE_NAME = '.env.test'
Dotenv.load(DOTENV_FILE_NAME)

REFRESH_TOKENS = ENV.fetch('REFRESH_TOKENS')
DEBUG = ENV.fetch('DEBUG', false)

class TokenStore
  def access_token
    ENV.fetch('FORTNOX_API_ACCESS_TOKEN')
  end

  def refresh_token
    unless REFRESH_TOKENS
      raise StandardError,
            'Something went wrong, #refresh_token should not be called during this test. ' \
            'Verify that the access token is valid.'
    end

    ENV.fetch('FORTNOX_API_REFRESH_TOKEN')
  end

  def access_token=(token)
    unless REFRESH_TOKENS
      raise StandardError,
            'Something went wrong, #access_token= should not be called during this test. ' \
            'Verify that the access token is valid.'
    end

    text = File.read(DOTENV_FILE_NAME)
    updated_text = text
                   .gsub(/FORTNOX_API_ACCESS_TOKEN=.*$/, "FORTNOX_API_ACCESS_TOKEN=#{token}")
    File.write(DOTENV_FILE_NAME, updated_text)
  end

  def refresh_token=(token)
    unless REFRESH_TOKENS
      raise StandardError,
            'Something went wrong, #refresh_token= should not be called during this test. ' \
            'Verify that the access token is valid.'
    end

    text = File.read(DOTENV_FILE_NAME)
    updated_text = text
                   .gsub(/FORTNOX_API_REFRESH_TOKEN=.*$/, "FORTNOX_API_REFRESH_TOKEN=#{token}")
    File.write(DOTENV_FILE_NAME, updated_text)
  end
end

module Helpers
  module Configuration
    def set_api_test_configuration
      Fortnox::API.configure do |config|
        config.token_stores = { default: TokenStore.new }
        config.debugging = DEBUG

        if DEBUG
          config.logger = lambda {
            logger = Logger.new($stdout)
            logger.level = Logger::DEBUG
            return logger
          }.call
        end

        if REFRESH_TOKENS
          config.client_id = ENV.fetch('FORTNOX_API_CLIENT_ID')
          config.client_secret = ENV.fetch('FORTNOX_API_CLIENT_SECRET')
        end
      end
    end
  end
end
