require "fortnox/api/repositories/base"
require "fortnox/api/models/order"
require "fortnox/api/mappers/order"

module Fortnox
  module API
    module Repository
      class Order < Repository::Base
        MODEL = Model::Order
        MAPPER = Mapper::Order
        URI = '/orders/'.freeze

        def initialize
          super(MODEL)
        end
      end
    end
  end
end
