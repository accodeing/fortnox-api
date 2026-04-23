# frozen_string_literal: true

require 'dry-struct'

module Fortnox
  module Structs
    class EDIInformation < Dry::Struct
      include Fortnox::Types

      transform_keys do |key|
        RestEasy::Conventions::PascalCase.new.parse(key)
      end

      # EDIGlobalLocationNumber Invoice address GLN for EDI
      attribute? :edi_global_location_number, Coercible::String.optional

      # EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
      attribute? :edi_global_location_number_delivery, Coercible::String.optional

      # EDIInvoiceExtra1 Extra EDI Information
      attribute? :edi_invoice_extra1, Coercible::String.optional

      # EDIInvoiceExtra2 Extra EDI Information
      attribute? :edi_invoice_extra2, Coercible::String.optional

      # EDIOurElectronicReference Our electronic reference for EDI
      attribute? :edi_our_electronic_reference, Coercible::String.optional

      # EDIYourElectronicReference Your electronic reference for EDI
      attribute? :edi_your_electronic_reference, Coercible::String.optional
    end
  end
end
