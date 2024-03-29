# frozen_string_literal: true

ENV['RUBY_ENV'] = 'test'

require 'simplecov'

SimpleCov.start

require 'rspec/collection_matchers'
require 'webmock/rspec'
require 'pry'
require 'support/matchers'
require 'support/helpers'
require 'support/vcr_setup'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.extend Helpers # Allow access to helpers in describe and context blocks
  config.include Helpers # Allow access to helpers in it and let blocks

  config.include Matchers::Type, type: :type

  config.order = 'random'

  WebMock.disable_net_connect!(allow: 'codeclimate.com')

  # Reset configuration after each test run
  config.after do
    Fortnox::API::DEFAULT_CONFIGURATION.each do |key, value|
      Fortnox::API.config.send("#{key}=", value)
    end
  end
end
