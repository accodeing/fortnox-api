# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/order'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Order do
  key_map =
    {
      administration_fee_vat: 'AdministrationFeeVAT',
      freight_vat: 'FreightVAT',
      total_vat: 'TotalVAT',
      vat_included: 'VATIncluded'
    }
  json_entity_type = 'Order'
  json_entity_collection = 'Orders'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper) { described_class.new }
  end
end
