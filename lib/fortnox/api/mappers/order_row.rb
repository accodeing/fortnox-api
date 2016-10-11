require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class OrderRow < Fortnox::API::Mapper::Base
        KEY_MAP = { vat: 'VAT' }
        JSON_ENTITY_WRAPPER = 'OrderRow'
        JSON_COLLECTION_WRAPPER = 'OrderRows'
      end

      Registry.register( OrderRow.canonical_name_sym, OrderRow )
    end
  end
end
