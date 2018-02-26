# frozen_string_literal: true

require 'fortnox/api/types/document_row'

module Fortnox
  module API
    module Types
      class InvoiceRow < DocumentRow
        STUB = {}.freeze

        # PriceExcludingVAT Price per unit excluding VAT.
        attribute :price_excluding_vat, Types::Nullable::Float.with(private: true)

        # TotalExcludingVAT  Total amount for the row excluding VAT.
        attribute :total_excluding_vat, Types::Nullable::Float.with(private: true)
      end
    end
  end
end
