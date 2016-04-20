require 'spec_helper'
require 'fortnox/api/models/order_row'
require 'fortnox/api/models/document_row_examples'

describe Fortnox::API::Model::OrderRow do
  it_behaves_like 'DocumentRow Model'
end
