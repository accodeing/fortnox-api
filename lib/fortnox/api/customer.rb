require "fortnox/api/models/customer"
require "fortnox/api/repositories/customer"
require "fortnox/api/validators/customer"

module Fortnox
  module API
    class Customer < Fortnox::API::Model::Customer

      def valid?
        Fortnox::API::Validator::Customer.validate( self )
      end

      def save
        self.class.repository.save( self )
      end

      def self.all
        repository.all
      end

      def self.only( filter )
        repository.only( filter )
      end

      def self.find( *args )
        repository.find( *args )
      end

      def self.repository
        @repository ||= Fortnox::API::Repository::Customer.new
      end

    end
  end
end
