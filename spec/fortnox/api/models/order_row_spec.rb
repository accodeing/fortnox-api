require 'spec_helper'
require 'fortnox/api/models/order_row'
require 'fortnox/api/models/examples/document_row'

RSpec.describe Fortnox::API::Model::OrderRow, type: :model, focus: true do
  valid_hash = { ordered_quantity: 10.5 }

  subject{ described_class }

  #it{ is_expected.to require_attribute( :ordered_quantity, valid_hash ) }

  it 'doesnt work' do
    subject.new( subject::STUB.merge({ price: -0.1 }) )
    expect( true ).to == false
  end

  #it_behaves_like 'DocumentRow', valid_hash
end
