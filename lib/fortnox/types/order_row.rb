# frozen_string_literal: true

require 'fortnox/types/document_row'

module Fortnox
  module Types
    class OrderRow < DocumentRow
      # OrderedQuantity Ordered quantity
      attribute :ordered_quantity, Required::Float
    end
  end
end
