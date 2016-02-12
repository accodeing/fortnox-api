require 'spec_helper'
require 'fortnox/api/models/invoice'
require 'fortnox/api/models/context'
require 'fortnox/api/models/order_base_examples'

describe Fortnox::API::Model::Invoice do
  include_context 'models context'

  it_behaves_like 'OrderBase', Fortnox::API::Model::InvoiceRow do
    let( :row_attribute ){ :invoice_rows }
  end

  include_examples 'having value objects', Fortnox::API::Model::EDIInformation do
    let( :attribute ){ :edi_information }
  end
end
