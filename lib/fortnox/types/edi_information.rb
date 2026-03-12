# frozen_string_literal: true

module Fortnox
  module Types
    class EDIInformation < Dry::Struct
      transform_keys do |key|
        RestEasy::Conventions::PascalCase.new.parse(key)
      end

      # EDIGlobalLocationNumber Invoice address GLN for EDI
      attribute? :edi_global_location_number, Nullable::String

      # EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
      attribute? :edi_global_location_number_delivery, Nullable::String

      # EDIInvoiceExtra1 Extra EDI Information
      attribute? :edi_invoice_extra1, Nullable::String

      # EDIInvoiceExtra2 Extra EDI Information
      attribute? :edi_invoice_extra2, Nullable::String

      # EDIOurElectronicReference Our electronic reference for EDI
      attribute? :edi_our_electronic_reference, Nullable::String

      # EDIYourElectronicReference Your electronic reference for EDI
      attribute? :edi_your_electronic_reference, Nullable::String
    end
  end
end
