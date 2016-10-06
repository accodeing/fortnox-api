require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class Invoice < Fortnox::API::Mapper::Base

        KEY_MAP = {
          administration_fee_vat: 'AdministrationFeeVAT',
          edi_information: 'EDIInformation',
          eu_quarterly_report: 'EUQuarterlyReport',
          freight_vat: 'FreightVAT',
          ocr: 'OCR',
          total_vat: 'TotalVAT',
          vat_included: 'VATIncluded'
        }.freeze
        JSON_ENTITY_WRAPPER = 'Invoice'.freeze
        JSON_COLLECTION_WRAPPER = 'Invoices'.freeze

      end
    end
  end
end
