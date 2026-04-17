# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.test.local', '.env.test')
require 'fortnox'
require 'vcr'
require 'webmock/rspec'

require 'faraday/net_http'
Faraday.default_adapter = :net_http

Fortnox.access_token = ENV.fetch('FORTNOX_ACCESS_TOKEN')

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<AUTHORIZATION>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end
  c.register_request_matcher :normalized_uri do |request_1, request_2|
    normalize = lambda { |uri|
      u = URI.parse(uri)
      u.path = u.path.chomp('/')
      u.to_s
    }
    normalize.call(request_1.uri) == normalize.call(request_2.uri)
  end
  c.default_cassette_options = {
    match_requests_on: [:method, :normalized_uri]
  }
end
