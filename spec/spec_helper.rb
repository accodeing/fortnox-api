# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env.test.local', '.env.test')
require 'fortnox'

require 'faraday/net_http'
Faraday.default_adapter = :net_http

Fortnox.access_token = ENV.fetch('FORTNOX_ACCESS_TOKEN')

require_relative 'support/vcr'
