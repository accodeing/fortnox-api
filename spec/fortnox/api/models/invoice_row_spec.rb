require 'spec_helper'
require 'fortnox/api/models/invoice_row'
require 'fortnox/api/models/examples/document_row_examples'

RSpec.describe Fortnox::API::Model::InvoiceRow, type: :model do
  subject{ described_class }

  it_behaves_like 'DocumentRow', {}
end
