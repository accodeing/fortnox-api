module Fortnox
  module API
    module Mapper
      class Order < Fortnox::API::Mapper::Base
        KEY_MAP =
          {
            administration_fee_vat: 'AdministrationFeeVAT',
            edi_information: 'EDIInformation',
            freight_vat: 'FreightVAT',
            total_vat: 'TotalVAT',
            vat_included: 'VATIncluded'
          }
      end
    end
  end
end
