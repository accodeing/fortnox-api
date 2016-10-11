require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class OrderRow < Fortnox::API::Mapper::Base
        KEY_MAP = { vat: 'VAT' }.freeze
        JSON_ENTITY_WRAPPER = 'OrderRow'.freeze
        JSON_COLLECTION_WRAPPER = 'OrderRows'.freeze
      end

      Registry.register( OrderRow.canonical_name_sym, OrderRow )
    end
  end
end
