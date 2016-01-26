require "fortnox/api/models/customer/entity"
require "fortnox/api/models/customer/repository"
require "fortnox/api/models/customer/validator"

module Fortnox
  module API
    class Customer < Fortnox::API::Entities::Customer

      def valid?
        Fortnox::API::Validators::Customer.validate( self )
      end

      def save
        self.class.repository.save( self )
      end

      def self.all
        repository.all
      end

      def self.find( *args )
        repository.find( *args )
      end

      def self.repository
        @repository ||= Fortnox::API::Repositories::Customer.new
      end

    end
  end
end

