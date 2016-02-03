require "fortnox/api/models/base"

module Fortnox
  module API
    module Model
      class EDIInformation < Base

        #EDIGlobalLocationNumber Invoice address GLN for EDI
        attribute :edi_global_location_number, String

        #EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
        attribute :edi_global_location_number_delivery, String

        #EDIInvoiceExtra1 Extra EDI Information
        attribute :edi_invoice_extra1, String

        #EDIInvoiceExtra2 Extra EDI Information
        attribute :edi_invoice_extra2, String

        #EDIOurElectronicReference Our electronic reference for EDI
        attribute :edi_our_electronic_reference, String

        #EDIYourElectronicReference Your electronic reference for EDI
        attribute :edi_your_electronic_reference, String
      end
    end
  end
end
