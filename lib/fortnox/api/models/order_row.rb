require "fortnox/api/models/row"

module Fortnox
  module API
    module Model
      class OrderRow < Row
        #OrderedQuantity Ordered quantity
        attribute :order_quantity, Float
      end
    end
  end
end
