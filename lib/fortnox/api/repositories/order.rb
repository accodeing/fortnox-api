# frozen_string_literal: true

require_relative 'base'
require_relative '../models/order'
require_relative '../mappers/order'

module Fortnox
  module API
    module Repository
      class Order < Base
        MODEL = Model::Order
        MAPPER = Mapper::Order
        URI = '/orders/'
      end
    end
  end
end
