require "set"
require "dotenv"
require "fortnox/api/base"
require "fortnox/api/version"
require "fortnox/api/entities/customer/customer"
require "fortnox/api/entities/customer/repository"
require "fortnox/api/entities/customer/validator"

Dotenv.load unless ENV['RUBY_ENV'] == 'test'

module Fortnox
  module API

    # Customer = Entities::Customer::Entity

    class << self
      extend Forwardable
      delegate [ :new, :get_access_token ] => Fortnox::API::Base

      def root
        File.dirname( __FILE__ ).to_s
      end

      def modules
        @@modules ||= lookup_modules
      end

    private

      def lookup_modules
        glob = '/api/entities/*'
        all_files_in_entities_directory = Dir.glob( root + glob )
        directories = all_files_in_entities_directory.select { |f| File.directory? f }
        directories.map { |d| d.split('/').last }
      end

    end

  end
end
