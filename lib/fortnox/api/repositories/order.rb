require "fortnox/api/repositories/base"
require "fortnox/api/models/order"
require "fortnox/api/mappers/order"

module Fortnox
  module API
    module Repository
      class Order < Fortnox::API::Repository::Base

        MODEL = Fortnox::API::Model::Order
        MAPPER = Fortnox::API::Mapper::Order
        URI = '/orders/'.freeze
        UNIQUE_ID = 'DocumentNumber' .freeze

      end
    end
  end
end
