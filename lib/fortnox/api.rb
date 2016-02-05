require "set"
require "dotenv"
require "fortnox/api/base"
require "fortnox/api/version"

Dotenv.load unless ENV['RUBY_ENV'] == 'test'

module Fortnox
  module API

    class RemoteServerError < ::RuntimeError
    end

    class << self
      @debugging = false
      attr_accessor :debugging
    end

    def self.get_access_token( *args )
      Base.get_access_token( *args )
    end

  end
end

require "fortnox/api/customer"
