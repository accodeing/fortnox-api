require "fortnox/api/models/row"

module Fortnox
  module API
    module Model
      class InvoiceRow < Row
        #PriceExcludingVAT Price per unit excluding VAT.
        attribute :price_excluding_vat, Float, writer: :private

        #TotalExcludingVAT  Total amount for the row excluding VAT.
        attribute :total_excluding_vat, Float, writer: :private
      end
    end
  end
end
