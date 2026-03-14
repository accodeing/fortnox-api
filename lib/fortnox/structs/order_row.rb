# frozen_string_literal: true

module Fortnox
  module Structs
    class OrderRow < DocumentRow
      # OrderedQuantity Ordered quantity
      attribute :ordered_quantity, Types::Coercible::Float
    end
  end
end
