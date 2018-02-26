# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/customer'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Customer do
  key_map =
    {
      vat_type: 'VATType',
      vat_number: 'VATNumber',
      email_invoice_bcc: 'EmailInvoiceBCC',
      email_invoice_cc: 'EmailInvoiceCC',
      email_offer_bcc: 'EmailOfferBCC',
      email_offer_cc: 'EmailOfferCC',
      email_order_bcc: 'EmailOrderBCC',
      email_order_cc: 'EmailOrderCC',
      show_price_vat_included: 'ShowPriceVATIncluded'
    }
  json_entity_type = 'Customer'
  json_entity_collection = 'Customers'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper) { described_class.new }
  end
end
