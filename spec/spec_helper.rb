ENV['RUBY_ENV'] = 'test'

require 'webmock/rspec'
require 'pry'
require "codeclimate-test-reporter"
require 'support/matchers'
require 'support/helpers'

CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.extend Helpers

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  WebMock.disable_net_connect!( allow: 'codeclimate.com' )

  config.after( :each ) do
    ENV['FORTNOX_API_BASE_URL'] = nil
    ENV['FORTNOX_API_CLIENT_SECRET'] = nil
    ENV['FORTNOX_API_ACCESS_TOKEN'] = nil
  end
end
