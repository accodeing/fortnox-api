# frozen_string_literal: true

module Helpers
  module Configuration
    def set_api_test_configuration
      Fortnox::API.configure do |config|
        config.client_secret = '9aBA8ZgsvR'
        config.access_tokens = ['ccaef817-d5d8-4b1c-a316-54f3e55c5c54']
      end
    end
  end
end
