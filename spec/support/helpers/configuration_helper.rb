# frozen_string_literal: true

require 'dotenv'
require 'jwt'

Dotenv.load('.env.test')

class Storage
  def access_token
    if ENV.fetch('MOCK_VALID_ACCESS_TOKEN') == 'true'
      # Mock long lived token to avoid using a real one from Fortnox
      # 1906691557 = Mon Jun 03 2030 04:32:37 GMT+0000
      return JWT.encode({ exp: 1_906_691_557 }, nil, 'none')
    end

    # When you want to use a real token, for instance to rerecord VCR
    # cassettes or when adding new integration specs, set `MOCK_VALID_ACCESS_TOKEN`
    # to false and provide a valid access token in `.env`.
    # See `bin/get_tokens` to issue valid tokens.
    Dotenv.load('.env')
    ENV.fetch('FORTNOX_API_ACCESS_TOKEN')
  end

  def refresh_token
    raise Exception,
          'Something went wrong, #refresh_token should not be called during this test. ' \
          'Verify that the access token is valid.'
  end

  def access_token=(_token)
    raise Exception,
          'Something went wrong, #access_token= should not be called during this test. ' \
          'Verify that the access token is valid.'
  end

  def refresh_token=(_token)
    raise Exception,
          'Something went wrong, #refresh_token= should not be called during this test. ' \
          'Verify that the access token is valid.'
  end
end

module Helpers
  module Configuration
    def set_api_test_configuration
      Fortnox::API.configure { |config| config.storage = Storage.new }
    end
  end
end
