require "fortnox/api/types"

module Fortnox
  module API
    module Types
      class EDIInformation < Types::Model
        STUB = {}.freeze
        
        #EDIGlobalLocationNumber Invoice address GLN for EDI
        attribute :edi_global_location_number, Types::Nullable::String

        #EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
        attribute :edi_global_location_number_delivery, Types::Nullable::String

        #EDIInvoiceExtra1 Extra EDI Information
        attribute :edi_invoice_extra1, Types::Nullable::String

        #EDIInvoiceExtra2 Extra EDI Information
        attribute :edi_invoice_extra2, Types::Nullable::String

        #EDIOurElectronicReference Our electronic reference for EDI
        attribute :edi_our_electronic_reference, Types::Nullable::String

        #EDIYourElectronicReference Your electronic reference for EDI
        attribute :edi_your_electronic_reference, Types::Nullable::String
      end
    end
  end
end
