# frozen_string_literal: true

require 'fortnox/types/document_row'

module Fortnox
  module Types
    class InvoiceRow < DocumentRow
      # PriceExcludingVAT Price per unit excluding VAT.
      attribute? :price_excluding_vat, Nullable::Float.with(private: true)

      # TotalExcludingVAT  Total amount for the row excluding VAT.
      attribute? :total_excluding_vat, Nullable::Float.with(private: true)
    end
  end
end
