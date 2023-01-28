# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_request do |request|
    if ENV.fetch('REFRESH_TOKENS')
      request.uri === 'https://apps.fortnox.se/oauth-v1/token'
    end
  end
  c.filter_sensitive_data('<AUTHORIZATION>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end
end
