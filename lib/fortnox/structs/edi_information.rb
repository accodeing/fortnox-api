# frozen_string_literal: true

module Fortnox
  module Structs
    class EDIInformation < Fortnox::Struct
      # EDIGlobalLocationNumber Invoice address GLN for EDI
      attribute? :edi_global_location_number, Types::UnsizedString

      # EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
      attribute? :edi_global_location_number_delivery, Types::UnsizedString

      # EDIInvoiceExtra1 Extra EDI Information
      attribute? :edi_invoice_extra1, Types::UnsizedString

      # EDIInvoiceExtra2 Extra EDI Information
      attribute? :edi_invoice_extra2, Types::UnsizedString

      # EDIOurElectronicReference Our electronic reference for EDI
      attribute? :edi_our_electronic_reference, Types::UnsizedString

      # EDIYourElectronicReference Your electronic reference for EDI
      attribute? :edi_your_electronic_reference, Types::UnsizedString
    end
  end
end
