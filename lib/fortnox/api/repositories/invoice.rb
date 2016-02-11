require "fortnox/api/repositories/base"
require "fortnox/api/models/invoice"

module Fortnox
  module API
    module Repository
      class Invoice < Fortnox::API::Repository::Base

        CONFIGURATION = Fortnox::API::Repository::Base::Options.new(
          uri: '/invoices/',
          json_list_wrapper: 'Invoices',
          json_unit_wrapper: 'Invoice',
          unique_id: 'DocumentNumber',
          attribute_name_to_json_key_map: {
            administration_fee_vat: 'AdministrationFeeVAT',
            edi_information: 'EDIInformation',
            eu_quarterly_report: 'EUQuarterlyReport',
            freight_vat: 'FreightVAT',
            ocr: 'OCR',
            total_vat: 'TotalVAT',
            vat_included: 'VATIncluded'
          },
          keys_filtered_on_save: [
            :url,
          ]
        )
        MODEL = Fortnox::API::Model::Invoice

        def initialize
          super( CONFIGURATION )
        end
      end
    end
  end
end
