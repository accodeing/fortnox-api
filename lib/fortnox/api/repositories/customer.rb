require "fortnox/api/repositories/base"
require "fortnox/api/models/customer"
require "fortnox/api/mappers/customer"

module Fortnox
  module API
    module Repository
      class Customer < Fortnox::API::Repository::Base

        CONFIGURATION = Fortnox::API::Repository::Base::Options.new(
          uri: '/customers/',
          json_collection_wrapper: 'Customers',
          json_entity_wrapper: 'Customer',
          unique_id: 'CustomerNumber',
          keys_filtered_on_save: [
            :url,
          ]
        )
        MODEL = Fortnox::API::Model::Customer
        MAPPER = Fortnox::API::Mapper::Customer

        def initialize
          super( CONFIGURATION )
        end

      end
    end
  end
end
