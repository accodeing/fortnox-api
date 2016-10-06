require 'spec_helper'
require 'fortnox/api/mappers/edi_information'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::EDIInformation do
  key_map = { 
    edi_global_location_number: 'EDIGlobalLocationNumber',
    edi_global_location_number_delivery: 'EDIGlobalLocationNumberDelivery',
    edi_invoice_extra1: 'EDIInvoiceExtra1',
    edi_invoice_extra2: 'EDIInvoiceExtra2',
    edi_our_electronic_reference: 'EDIOurElectronicReference',
    edi_your_electronic_reference: 'EDIYourElectronicReference'
  }
  json_entity_type = 'EDIInformation'
  json_entity_collection = 'EDIInformation'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper){ described_class.new }
  end
end
