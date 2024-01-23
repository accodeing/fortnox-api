# frozen_string_literal: true

require_relative 'base'

module Fortnox
  module API
    module Mapper
      class EDIInformation < Fortnox::API::Mapper::Base
        KEY_MAP = {
          edi_global_location_number: 'EDIGlobalLocationNumber',
          edi_global_location_number_delivery: 'EDIGlobalLocationNumberDelivery',
          edi_invoice_extra1: 'EDIInvoiceExtra1',
          edi_invoice_extra2: 'EDIInvoiceExtra2',
          edi_our_electronic_reference: 'EDIOurElectronicReference',
          edi_your_electronic_reference: 'EDIYourElectronicReference'
        }.freeze
        JSON_ENTITY_WRAPPER = JSON_COLLECTION_WRAPPER = 'EDIInformation'
      end

      Registry.register(EDIInformation.canonical_name_sym, EDIInformation)
    end
  end
end
