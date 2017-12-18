require "fortnox/api/repositories/base"
require "fortnox/api/models/order"
require "fortnox/api/mappers/order"

module Fortnox
  module API
    module Repository
      class Order < Base
        MODEL = Model::Order
        MAPPER = Mapper::Order
        URI = '/orders/'.freeze
      end
    end
  end
end
