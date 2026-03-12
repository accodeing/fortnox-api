# frozen_string_literal: true

require 'fortnox/types/document_row'

module Fortnox
  module Types
    class OrderRowClass < DocumentRow
      with_stub ordered_quantity: 0

      # OrderedQuantity Ordered quantity
      attribute :ordered_quantity, Types::Required::Float
    end

    OrderRow = Types.Constructor( OrderRowClass )
  end
end
