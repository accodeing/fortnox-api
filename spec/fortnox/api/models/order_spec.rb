require 'spec_helper'
require 'fortnox/api/models/order'
require 'fortnox/api/models/document_base_examples'

describe Fortnox::API::Model::Order, type: :model do
  subject{ described_class }

  it_behaves_like 'DocumentBase Model',
                  Fortnox::API::Model::OrderRow,
                  :order_rows
end
