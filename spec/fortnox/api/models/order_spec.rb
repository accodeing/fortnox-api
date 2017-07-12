require 'spec_helper'
require 'fortnox/api/models/order'
require 'fortnox/api/models/examples/document_base'

describe Fortnox::API::Model::Order, type: :model do
  it_behaves_like 'DocumentBase Model',
                  Fortnox::API::Types::OrderRow,
                  :order_rows,
                  valid_row_hash: { ordered_quantity: 1.1 }
end
