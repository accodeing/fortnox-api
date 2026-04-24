# frozen_string_literal: true

require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<AUTHORIZATION>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end
  c.filter_sensitive_data('<CLIENT_ID>') { ENV.fetch('FORTNOX_CLIENT_ID', 'dummy') }
  c.filter_sensitive_data('<CLIENT_SECRET>') { ENV.fetch('FORTNOX_CLIENT_SECRET', 'dummy') }
  c.filter_sensitive_data('<TENANT_ID>') { ENV.fetch('FORTNOX_TENANT_ID', 'dummy') }
  c.filter_sensitive_data('<ACCESS_TOKEN>') { ENV.fetch('FORTNOX_ACCESS_TOKEN', 'dummy') }
  c.filter_sensitive_data('<ACCESS_TOKEN>') do |interaction|
    if interaction.response.headers['Content-Type']&.first&.include?('application/json')
      body = begin
        JSON.parse(interaction.response.body)
      rescue JSON::ParserError
        nil
      end
      body&.dig('access_token')
    end
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
      actual_json = begin
        JSON.parse(actual.body)
      rescue JSON::ParserError
        actual.body
      end
      expected_json = begin
        JSON.parse(expected.body)
      rescue JSON::ParserError
        expected.body
      end
      actual_json == expected_json
    end
  end
  c.default_cassette_options = {
    match_requests_on: [:method, :normalized_uri, :json_body]
  }
end
