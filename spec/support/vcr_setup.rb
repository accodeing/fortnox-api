# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<AUTHORIZATION>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end
  c.filter_sensitive_data('<REFRESH_TOKEN>') do |interaction|
    interaction.request.body.split('&refresh_token=').last
  end
  c.filter_sensitive_data('<ACCESS_TOKEN>') do |interaction|
    body = interaction.response.body
    access_token = /"access_token":"[^"]*"/.match(body)
    access_token ? access_token.to_s.split('"access_token":"').last.chop : ''
  end
  c.filter_sensitive_data('<REFRESH_TOKEN>') do |interaction|
    body = interaction.response.body
    refresh_token = /"refresh_token":"[^"]*"/.match(body)
    refresh_token ? refresh_token.to_s.split('"refresh_token":"').last.chop : ''
  end
end
