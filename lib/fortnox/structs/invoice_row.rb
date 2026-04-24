# frozen_string_literal: true

module Fortnox
  module Structs
    class InvoiceRow < DocumentRow
      using RestEasy::Refinements

      # PriceExcludingVAT Price per unit excluding VAT.
      attr :price_excluding_vat <=> 'PriceExcludingVAT', Coercible::Float.optional, :read_only

      # TotalExcludingVAT Total amount for the row excluding VAT.
      attr :total_excluding_vat <=> 'TotalExcludingVAT', Coercible::Float.optional, :read_only
    end
  end
end
