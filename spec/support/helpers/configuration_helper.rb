# frozen_string_literal: true

require 'dotenv'

module Helpers
  module Configuration
    def set_api_test_configuration
      Fortnox::API.configure do |config|
        config.client_secret = ENV['FORTNOX_API_CLIENT_SECRET']
        config.access_tokens = [ENV['FORTNOX_API_ACCESS_TOKEN']]
      end
    end
  end
end
