require 'spec_helper'
require 'fortnox/api/mappers/invoice_row'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::InvoiceRow do
  key_map = {
    vat: 'VAT',
    price_excluding_vat: 'PriceExcludingVAT',
    total_excluding_vat: 'TotalExcludingVAT'
  }

  json_entity_type = 'InvoiceRow'
  json_entity_collection = 'InvoiceRows'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper){ described_class.new }
  end
end
