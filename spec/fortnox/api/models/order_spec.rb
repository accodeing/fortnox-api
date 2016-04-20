require 'spec_helper'
require 'fortnox/api/models/order'
require 'fortnox/api/models/document_base_examples'

describe Fortnox::API::Model::Order do

  it_behaves_like 'DocumentBase',
                  Fortnox::API::Model::OrderRow,
                  :order_rows
end
