require 'spec_helper'
require 'fortnox/api/models/invoice'
require 'fortnox/api/models/context'
require 'fortnox/api/models/document_base_examples'

describe Fortnox::API::Model::Invoice, type: :model do
  valid_hash = { customer_number: '12345' }

  subject{ described_class }

  include_context 'models context'

  it_behaves_like 'DocumentBase Model',
                  Fortnox::API::Model::InvoiceRow,
                  :invoice_rows,
                  valid_hash

  include_examples 'having value objects', Fortnox::API::Model::EDIInformation do
    let( :attribute ){ :edi_information }
  end
end
