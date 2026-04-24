# frozen_string_literal: true

module Fortnox
  module Structs
    class EDIInformation < Fortnox::Struct
      using RestEasy::Refinements
      include Fortnox::Types

      # EDIGlobalLocationNumber Invoice address GLN for EDI
      attr :edi_global_location_number <=> 'EDIGlobalLocationNumber', Coercible::String.optional

      # EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
      attr :edi_global_location_number_delivery <=> 'EDIGlobalLocationNumberDelivery', Coercible::String.optional

      # EDIInvoiceExtra1 Extra EDI Information
      attr :edi_invoice_extra1 <=> 'EDIInvoiceExtra1', Coercible::String.optional

      # EDIInvoiceExtra2 Extra EDI Information
      attr :edi_invoice_extra2 <=> 'EDIInvoiceExtra2', Coercible::String.optional

      # EDIOurElectronicReference Our electronic reference for EDI
      attr :edi_our_electronic_reference <=> 'EDIOurElectronicReference', Coercible::String.optional

      # EDIYourElectronicReference Your electronic reference for EDI
      attr :edi_your_electronic_reference <=> 'EDIYourElectronicReference', Coercible::String.optional
    end
  end
end
