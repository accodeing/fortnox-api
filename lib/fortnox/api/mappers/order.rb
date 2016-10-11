require "fortnox/api/mappers/base"
require "fortnox/api/mappers/edi_information"
require "fortnox/api/mappers/email_information"
require "fortnox/api/mappers/order_row"

module Fortnox
  module API
    module Mapper
      class Order < Fortnox::API::Mapper::Base
        KEY_MAP = {
          administration_fee_vat: 'AdministrationFeeVAT',
          freight_vat: 'FreightVAT',
          total_vat: 'TotalVAT',
          vat_included: 'VATIncluded'
        }.freeze
        JSON_ENTITY_WRAPPER = 'Order'.freeze
        JSON_COLLECTION_WRAPPER = 'Orders'.freeze
      end

      Registry.register( Order.canonical_name_sym, Order )
    end
  end
end
