require "fortnox/api/models/document_row"

module Fortnox
  module API
    module Model
      class OrderRow < Fortnox::API::Types::Model
        STUB = { ordered_quantity: 0 }.freeze

        DocumentRow.ify self

        #OrderedQuantity Ordered quantity
        attribute :ordered_quantity, Types::Required::Float
      end
    end
  end
end
