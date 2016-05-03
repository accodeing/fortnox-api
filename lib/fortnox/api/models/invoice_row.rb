require "fortnox/api/models/document_row"

module Fortnox
  module API
    module Model
      class InvoiceRow < Fortnox::API::Model::Base
        include DocumentRow

        #PriceExcludingVAT Price per unit excluding VAT.
        #TODO: Writer should be private!
        attribute :price_excluding_vat, Float

        #TotalExcludingVAT  Total amount for the row excluding VAT.
        #TODO: Writer should be private!
        attribute :total_excluding_vat, Float
      end
    end
  end
end
