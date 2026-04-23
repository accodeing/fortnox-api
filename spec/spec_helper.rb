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
  c.register_request_matcher :normalized_uri do |actual, expected|
    normalize = lambda { |uri|
      u = URI.parse(uri)
      u.path = u.path.chomp('/')
      u.to_s
    }
    normalize.call(actual.uri) == normalize.call(expected.uri)
  end
  c.register_request_matcher :json_body do |actual, expected|
    if actual.body.empty? && expected.body.empty?
      true
    elsif actual.body.empty? || expected.body.empty?
      false
    else
      actual_json = JSON.parse(actual.body) rescue actual.body
      expected_json = JSON.parse(expected.body) rescue expected.body
      actual_json == expected_json
    end
  end
  c.default_cassette_options = {
    match_requests_on: [:method, :normalized_uri, :json_body]
  }
end
