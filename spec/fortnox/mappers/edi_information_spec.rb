# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Mappers::EDIInformation do
  let(:api_keys) do
    [
      'EDIGlobalLocationNumber',
      'EDIGlobalLocationNumberDelivery',
      'EDIInvoiceExtra1',
      'EDIInvoiceExtra2',
      'EDIOurElectronicReference',
      'EDIYourElectronicReference'
    ]
  end

  let(:model_keys) do
    [
      :edi_global_location_number,
      :edi_global_location_number_delivery,
      :edi_invoice_extra1,
      :edi_invoice_extra2,
      :edi_our_electronic_reference,
      :edi_your_electronic_reference
    ]
  end

  describe '.parse' do
    it 'maps each EDI-prefixed API key to its model attribute', :aggregate_failures do
      api_data = api_keys.zip(['a', 'b', 'c', 'd', 'e', 'f']).to_h
      result = described_class.parse(api_data)
      model_keys.zip(['a', 'b', 'c', 'd', 'e', 'f']).each do |attr, value|
        expect(result.public_send(attr)).to eq(value)
      end
    end
  end

  describe '.serialise' do
    it 'maps each model attribute back to its EDI-prefixed API key' do
      attrs = model_keys.zip(['a', 'b', 'c', 'd', 'e', 'f']).to_h
      struct = Fortnox::Structs::EDIInformation.new(attrs)
      expect(described_class.serialise(struct)).to eq(api_keys.zip(['a', 'b', 'c', 'd', 'e', 'f']).to_h)
    end
  end
end
