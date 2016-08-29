require "fortnox/api/repositories/base"
require "fortnox/api/models/order"
require "fortnox/api/mappers/order"

module Fortnox
  module API
    module Repository
      class Order < Fortnox::API::Repository::Base

        CONFIGURATION = Fortnox::API::Repository::Base::Options.new(
          uri: '/orders/',
          json_collection_wrapper: 'Orders',
          json_entity_wrapper: 'Order',
          unique_id: 'DocumentNumber',
          keys_filtered_on_save: [
            :url,
          ]
        )
        MODEL = Fortnox::API::Model::Order
        MAPPER = Fortnox::API::Mapper::Order

        def initialize
          super( CONFIGURATION )
        end
      end
    end
  end
end
