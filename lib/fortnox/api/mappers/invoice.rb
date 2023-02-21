# frozen_string_literal: true

require_relative 'base'
require_relative 'edi_information'
require_relative 'email_information'
require_relative 'invoice_row'

module Fortnox
  module API
    module Mapper
      class Invoice < Fortnox::API::Mapper::Base
        KEY_MAP = {
          administration_fee_vat: 'AdministrationFeeVAT',
          edi_information: 'EDIInformation',
          eu_quarterly_report: 'EUQuarterlyReport',
          freight_vat: 'FreightVAT',
          housework: 'HouseWork',
          ocr: 'OCR',
          total_vat: 'TotalVAT',
          vat_included: 'VATIncluded'
        }.freeze
        JSON_ENTITY_WRAPPER = 'Invoice'
        JSON_COLLECTION_WRAPPER = 'Invoices'
      end

      Registry.register(Invoice.canonical_name_sym, Invoice)
    end
  end
end
