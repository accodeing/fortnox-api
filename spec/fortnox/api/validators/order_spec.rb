require 'spec_helper'
require 'fortnox/api/models/order'
require 'fortnox/api/validators/order'
require 'fortnox/api/validators/document_base_examples'

describe Fortnox::API::Validator::Order do
  it_behaves_like 'DocumentBase Validator', Fortnox::API::Model::Order
end

