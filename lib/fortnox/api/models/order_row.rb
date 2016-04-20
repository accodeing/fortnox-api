require "fortnox/api/models/document_row"

module Fortnox
  module API
    module Model
      class OrderRow < Fortnox::API::Model::Base
        include DocumentRow
        #OrderedQuantity Ordered quantity
        attribute :order_quantity, Float
      end
    end
  end
end
