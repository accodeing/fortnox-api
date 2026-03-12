# frozen_string_literal: true

require 'fortnox/types/document_row'

module Fortnox
  module Types
    class InvoiceRowClass < DocumentRow
      # PriceExcludingVAT Price per unit excluding VAT.
      attribute? :price_excluding_vat, Types::Nullable::Float.with(private: true)

      # TotalExcludingVAT  Total amount for the row excluding VAT.
      attribute? :total_excluding_vat, Types::Nullable::Float.with(private: true)
    end

    InvoiceRow = Types.Constructor( InvoiceRowClass )
  end
end
