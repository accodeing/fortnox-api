# frozen_string_literal: true

require 'fortnox/api/mappers/base'

module Fortnox
  module API
    module Mapper
      class OrderRow < Fortnox::API::Mapper::Base
        KEY_MAP = { vat: 'VAT' }.freeze
        JSON_ENTITY_WRAPPER = 'OrderRow'
        JSON_COLLECTION_WRAPPER = 'OrderRows'
      end

      Registry.register(OrderRow.canonical_name_sym, OrderRow)
      Registry.register(:orderrows, OrderRow)
    end
  end
end
