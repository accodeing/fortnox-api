# frozen_string_literal: true

require 'dotenv'
require 'jwt'

DOTENV_FILE_NAME = '.env.test'
Dotenv.load(DOTENV_FILE_NAME)

REFRESH_TOKENS = ENV.fetch('REFRESH_TOKENS')

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
    File.open(DOTENV_FILE_NAME, 'w') { |file| file.write(updated_text) }
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
    File.open(DOTENV_FILE_NAME, 'w') { |file| file.write(updated_text) }
  end
end

module Helpers
  module Configuration
    def set_api_test_configuration
      Fortnox::API.configure do |config|
        config.token_stores = { default: TokenStore.new }
        config.debugging = ENV.fetch('DEBUGGING', false)

        if REFRESH_TOKENS
          config.client_id = ENV.fetch('FORTNOX_API_CLIENT_ID')
          config.client_secret = ENV.fetch('FORTNOX_API_CLIENT_SECRET')
        end
      end
    end
  end
end
