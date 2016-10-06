require 'spec_helper'
require 'fortnox/api/mappers/order'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Order do
  key_map =
    {
      administration_fee_vat: 'AdministrationFeeVAT',
      edi_information: Fortnox::API::Mapper::EDIInformation,
      email_information: Fortnox::API::Mapper::EmailInformation,
      freight_vat: 'FreightVAT',
      order_rows: Fortnox::API::Mapper::OrderRow,
      total_vat: 'TotalVAT',
      vat_included: 'VATIncluded'
    }
  json_entity_type = 'Order'
  json_entity_collection = 'Orders'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper){ described_class.new }
  end
end
