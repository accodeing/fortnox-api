# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/invoice_row'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::InvoiceRow do
  key_map = {
    housework: 'HouseWork',
    housework_hours_to_report: 'HouseWorkHoursToReport',
    housework_type: 'HouseWorkType',
    price_excluding_vat: 'PriceExcludingVAT',
    total_excluding_vat: 'TotalExcludingVAT',
    vat: 'VAT'
  }

  json_entity_type = 'InvoiceRow'
  json_entity_collection = 'InvoiceRows'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper) { described_class.new }
  end
end
