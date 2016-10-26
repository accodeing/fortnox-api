require "fortnox/api/types/document_row"

module Fortnox
  module API
    module Types
      class InvoiceRow < Fortnox::API::Types::Model
        STUB = {}.freeze
        
        DocumentRow.ify self

        #PriceExcludingVAT Price per unit excluding VAT.
        attribute :price_excluding_vat, Types::Nullable::Float.with( private: true )

        #TotalExcludingVAT  Total amount for the row excluding VAT.
        attribute :total_excluding_vat, Types::Nullable::Float.with( private: true )
      end
    end
  end
end
