require "fortnox/api/repository/base"

module Fortnox
  module API
    module Repositories
      class Customer < Fortnox::API::Repository::Base

        def initialize
          super(
            base_uri: '/customers/',
            json_list_wrapper: 'Customers',
            json_unit_wrapper: 'Customer',
            key_map: {
              vat_type: "VATType",
            }
          )
        end

      private

        def instansiate( hash )
          Fortnox::API::Customer::Entity.new( hash )
        end

      end
    end
  end
end
