require "fortnox/api/mappers/base"
require "fortnox/api/mappers/edi_information"
require "fortnox/api/mappers/email_information"
require "fortnox/api/mappers/invoice_row"

module Fortnox
  module API
    module Mapper
      class Invoice < Fortnox::API::Mapper::Base

        KEY_MAP = {
          administration_fee_vat: 'AdministrationFeeVAT',
          edi_information: Fortnox::API::Mapper::EDIInformation,
          email_information: Fortnox::API::Mapper::EmailInformation,
          eu_quarterly_report: 'EUQuarterlyReport',
          freight_vat: 'FreightVAT',
          invoice_rows: Fortnox::API::Mapper::InvoiceRow,
          ocr: 'OCR',
          total_vat: 'TotalVAT',
          vat_included: 'VATIncluded'
        }.freeze
        JSON_ENTITY_WRAPPER = 'Invoice'.freeze
        JSON_COLLECTION_WRAPPER = 'Invoices'.freeze
      end

      Registry.register( Invoice.canonical_name_sym, Invoice )
    end
  end
end
