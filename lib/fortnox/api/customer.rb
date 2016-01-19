require "fortnox/api/entities/customer/entity"
require "fortnox/api/entities/customer/repository"
require "fortnox/api/entities/customer/validator"

module Fortnox
  module API
    Customer = Fortnox::API::Enteties::Customer

    class Customer
      @@repository = Fortnox::API::Repositories::Customer.new
      @@validator = Fortnox::API::Validators::Customer.new

      delegate [:save, :find, :all] => :@@repository
      delegate [:valid?] => :@@validator
    end
  end
end

