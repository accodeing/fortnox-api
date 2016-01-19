require "fortnox/api/models/customer/entity"
require "fortnox/api/models/customer/repository"
require "fortnox/api/models/customer/validator"

module Fortnox
  module API
    Customer = Fortnox::API::Enteties::Customer

    class Customer
      @@repository = Fortnox::API::Repositories::Customer.new
      @@validator = Fortnox::API::Validators::Customer.new

      delegate [:save] => :@@repository
      delegate [:valid?] => :@@validator

      def self.all
        @@repository.all
      end

      def self.find( *args )
        @@repository.find( *args )
      end
    end
  end
end

