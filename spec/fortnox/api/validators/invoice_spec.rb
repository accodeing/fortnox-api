require 'spec_helper'
require 'fortnox/api/models/invoice'
require 'fortnox/api/validators/invoice'
require 'fortnox/api/validators/document_base_examples'

describe Fortnox::API::Validator::Invoice do
  it_behaves_like 'DocumentBase Validator', Fortnox::API::Model::Invoice
end
