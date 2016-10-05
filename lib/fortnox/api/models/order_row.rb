require "fortnox/api/models/document_row"

module Fortnox
  module API
    module Model
      class OrderRow < Fortnox::API::Types::Model
        DocumentRow.ify self

        #OrderedQuantity Ordered quantity
        attribute :order_quantity, Types::Required::Float
      end
    end
  end
end
