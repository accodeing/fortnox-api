require 'spec_helper'
require 'fortnox/api/models/order_row'
require 'fortnox/api/models/examples/document_row'

RSpec.describe Fortnox::API::Model::OrderRow, type: :model do
  valid_hash = { order_quantity: 10.5 }

  subject{ described_class }

  it{ is_expected.to require_attribute( :order_quantity, valid_hash ) }

  it_behaves_like 'DocumentRow', valid_hash
end
