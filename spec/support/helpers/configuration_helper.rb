# frozen_string_literal: true

require 'dotenv'
require 'jwt'

DOTENV_FILE_NAME = '.env.test'
Dotenv.load(DOTENV_FILE_NAME)

DEBUG = ENV.fetch('DEBUG', false) == true

module Helpers
  module Configuration
    def set_api_test_configuration # rubocop:disable Metrics/MethodLength
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

      Fortnox::API.access_token = ENV.fetch('FORTNOX_API_ACCESS_TOKEN')
    end
  end
end
