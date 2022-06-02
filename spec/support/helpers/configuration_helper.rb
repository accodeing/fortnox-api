# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.test')

class FixedTokenStore
  def access_token
    ENV.fetch('FORTNOX_API_ACCESS_TOKEN')
  end

  def refresh_token
    raise Exception,
          "Something went wrong, #refresh_token should not be called during this test." \
          "Check that the access token is valid."
  end

  def access_token=(token);
    raise Exception,
          "Something went wrong, #access_token= should not be called during this test." \
          "Check that the access token is valid."
  end

  def refresh_token=(token)
    raise Exception,
          "Something went wrong, #refresh_token= should not be called during this test." \
          "Check that the access token is valid."
  end
end

module Helpers
  module Configuration

    def set_api_test_configuration
      Fortnox::API.configure { |config| config.storage = FixedTokenStore.new }
    end
  end
end
