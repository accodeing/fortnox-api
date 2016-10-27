require 'spec_helper'
require 'fortnox/api/models/invoice'
require 'fortnox/api/models/examples/document_base'

describe Fortnox::API::Model::Invoice, type: :model do
  valid_hash = { customer_number: '12345' }

  it_behaves_like 'DocumentBase Model',
                  Fortnox::API::Types::InvoiceRow,
                  :invoice_rows,
                  valid_hash
end
