require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class Order < Fortnox::API::Mapper::Base

          KEY_MAP = {
            administration_fee_vat: 'AdministrationFeeVAT',
            edi_information: 'EDIInformation',
            freight_vat: 'FreightVAT',
            total_vat: 'TotalVAT',
            vat_included: 'VATIncluded'
          }.freeze
          JSON_ENTITY_WRAPPER = 'Order'.freeze
          JSON_COLLECTION_WRAPPER = 'Orders'.freeze

      end
    end
  end
end
