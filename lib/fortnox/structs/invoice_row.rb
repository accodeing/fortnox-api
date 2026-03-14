# frozen_string_literal: true

module Fortnox
  module Structs
    class InvoiceRow < DocumentRow
      # PriceExcludingVAT Price per unit excluding VAT.
      attribute? :price_excluding_vat, Coercible::Float.optional.with(private: true)

      # TotalExcludingVAT  Total amount for the row excluding VAT.
      attribute? :total_excluding_vat, Coercible::Float.optional.with(private: true)
    end
  end
end
