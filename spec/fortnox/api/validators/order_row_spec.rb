require 'spec_helper'
require 'fortnox/api/models/order_row'
require 'fortnox/api/validators/order_row'
require 'fortnox/api/validators/document_row_examples'

describe Fortnox::API::Validator::OrderRow do
  it_behaves_like 'DocumentRow Validator' do
    let( :valid_row_model ){ Fortnox::API::Model::OrderRow.new }
  end
end
