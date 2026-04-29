# frozen_string_literal: true

module Fortnox
  module Structs
    class EDIInformation < Fortnox::Struct
      # EDIGlobalLocationNumber Invoice address GLN for EDI
      attribute? :edi_global_location_number, Types::Coercible::String.optional

      # EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
      attribute? :edi_global_location_number_delivery, Types::Coercible::String.optional

      # EDIInvoiceExtra1 Extra EDI Information
      attribute? :edi_invoice_extra1, Types::Coercible::String.optional

      # EDIInvoiceExtra2 Extra EDI Information
      attribute? :edi_invoice_extra2, Types::Coercible::String.optional

      # EDIOurElectronicReference Our electronic reference for EDI
      attribute? :edi_our_electronic_reference, Types::Coercible::String.optional

      # EDIYourElectronicReference Your electronic reference for EDI
      attribute? :edi_your_electronic_reference, Types::Coercible::String.optional
    end
  end
end
