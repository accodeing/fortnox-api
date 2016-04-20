require 'spec_helper'
require 'fortnox/api/models/invoice_row'
require 'fortnox/api/models/document_row_examples'

describe Fortnox::API::Model::InvoiceRow do
  it_behaves_like 'DocumentRow'
end
