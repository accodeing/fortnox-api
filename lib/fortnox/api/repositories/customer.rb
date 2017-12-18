require "fortnox/api/repositories/base"
require "fortnox/api/models/customer"
require "fortnox/api/mappers/customer"

module Fortnox
  module API
    module Repository
      class Customer < Base
        MODEL = Model::Customer
        MAPPER = Mapper::Customer
        URI = '/customers/'.freeze
      end
    end
  end
end
