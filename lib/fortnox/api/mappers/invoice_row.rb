# frozen_string_literal: true

require 'fortnox/api/mappers/base'

module Fortnox
  module API
    module Mapper
      class InvoiceRow < Fortnox::API::Mapper::Base
        KEY_MAP = {
          vat: 'VAT',
          price_excluding_vat: 'PriceExcludingVAT',
          total_excluding_vat: 'TotalExcludingVAT'
        }.freeze
        JSON_ENTITY_WRAPPER = 'InvoiceRow'
        JSON_COLLECTION_WRAPPER = 'InvoiceRows'
      end

      Registry.register(InvoiceRow.canonical_name_sym, InvoiceRow)
      Registry.register(:invoicerows, InvoiceRow)
    end
  end
end
