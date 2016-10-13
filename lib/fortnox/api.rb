require "set"
require "dotenv"
require "fortnox/api/base"
require "fortnox/api/version"
require 'logger'

Dotenv.load unless ENV['RUBY_ENV'] == 'test'

module Fortnox
  module API

    class RemoteServerError < ::RuntimeError
    end

    class << self
      @debugging = false
      @logger = Logger.new(STDOUT)
      attr_accessor :debugging
      attr_accessor :logger

      logger.level = Logger::WARN
    end

    def self.get_access_token
      Base.get_access_token
    end

    Registry = Dry::Container.new
  end
end

require "fortnox/api/models"
require "fortnox/api/repositories"
