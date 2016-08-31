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

          def initialize
            super( KEY_MAP )
          end
       end
    end
  end
end
