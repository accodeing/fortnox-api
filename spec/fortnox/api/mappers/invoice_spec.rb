require 'spec_helper'
require 'fortnox/api/mappers/invoice'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Invoice do
  key_map =
    {
      administration_fee_vat: 'AdministrationFeeVAT',
      edi_information: Fortnox::API::Mapper::EDIInformation,
      email_information: Fortnox::API::Mapper::EmailInformation,
      eu_quarterly_report: 'EUQuarterlyReport',
      freight_vat: 'FreightVAT',
      invoice_rows: Fortnox::API::Mapper::InvoiceRow,
      ocr: 'OCR',
      total_vat: 'TotalVAT',
      vat_included: 'VATIncluded'
    }

  json_entity_type = 'Invoice'
  json_entity_collection = 'Invoices'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper){ described_class.new }
  end
end
