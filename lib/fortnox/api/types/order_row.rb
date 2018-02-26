# frozen_string_literal: true

require 'fortnox/api/types/document_row'

module Fortnox
  module API
    module Types
      class OrderRow < DocumentRow
        STUB = { ordered_quantity: 0 }.freeze

        # OrderedQuantity Ordered quantity
        attribute :ordered_quantity, Types::Required::Float
      end
    end
  end
end
