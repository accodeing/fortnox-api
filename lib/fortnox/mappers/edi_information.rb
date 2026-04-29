# frozen_string_literal: true

module Fortnox
  module Mappers
    class EDIInformation < Struct
      struct    Structs::EDIInformation
      overrides edi_global_location_number: 'EDIGlobalLocationNumber',
                edi_global_location_number_delivery: 'EDIGlobalLocationNumberDelivery',
                edi_invoice_extra1: 'EDIInvoiceExtra1',
                edi_invoice_extra2: 'EDIInvoiceExtra2',
                edi_our_electronic_reference: 'EDIOurElectronicReference',
                edi_your_electronic_reference: 'EDIYourElectronicReference'
    end
  end
end
