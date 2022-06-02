# frozen_string_literal: true

require_relative 'base'
require_relative 'edi_information'
require_relative 'email_information'
require_relative 'order_row'

module Fortnox
  module API
    module Mapper
      class Order < Fortnox::API::Mapper::Base
        KEY_MAP = {
          administration_fee_vat: 'AdministrationFeeVAT',
          freight_vat: 'FreightVAT',
          housework: 'HouseWork',
          total_vat: 'TotalVAT',
          vat_included: 'VATIncluded'
        }.freeze
        JSON_ENTITY_WRAPPER = 'Order'
        JSON_COLLECTION_WRAPPER = 'Orders'
      end

      Registry.register(Order.canonical_name_sym, Order)
    end
  end
end
