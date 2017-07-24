require 'spec_helper'
require 'fortnox/api/models/invoice'
require 'fortnox/api/models/examples/document_base'

describe Fortnox::API::Model::Invoice, type: :model do
  it_behaves_like 'DocumentBase Model',
                  Fortnox::API::Types::InvoiceRow,
                  :invoice_rows
end
