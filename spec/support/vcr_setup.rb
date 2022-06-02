# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<AUTHORIZATION>') do |interaction|
    interaction.request.headers['Authorization'].first
  end
end
