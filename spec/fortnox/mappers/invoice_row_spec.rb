# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Mappers::InvoiceRow do
  describe '.parse' do
    it 'maps the VAT-suffixed API keys to their model attributes', :aggregate_failures do
      result = described_class.parse('PriceExcludingVAT' => 100.0, 'TotalExcludingVAT' => 1000.0)
      expect(result.price_excluding_vat).to eq(100.0)
      expect(result.total_excluding_vat).to eq(1000.0)
    end

    it 'inherits HouseWork-prefixed overrides from DocumentRow' do
      result = described_class.parse('HouseWork' => true)
      expect(result.housework).to be(true)
    end
  end

  describe '.serialise' do
    it 'excludes VAT-suffixed attributes (they are read-only)', :aggregate_failures do
      struct = Fortnox::Structs::InvoiceRow.new(article_number: '101', price_excluding_vat: 100.0,
                                                total_excluding_vat: 1000.0)
      result = described_class.serialise(struct)
      expect(result).not_to have_key('PriceExcludingVAT')
      expect(result).not_to have_key('TotalExcludingVAT')
    end

    it 'inherits HouseWork-prefixed overrides from DocumentRow' do
      struct = Fortnox::Structs::InvoiceRow.new(housework: true)
      expect(described_class.serialise(struct)).to include('HouseWork' => true)
    end
  end
end
