# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Mappers::OrderRow do
  describe '.parse' do
    it 'parses OrderRow-specific attributes via the convention' do
      result = described_class.parse('OrderedQuantity' => 7.0)
      expect(result.ordered_quantity).to eq(7.0)
    end

    it 'inherits HouseWork-prefixed overrides from DocumentRow' do
      result = described_class.parse('HouseWork' => true)
      expect(result.housework).to be(true)
    end
  end

  describe '.serialise' do
    it 'serialises OrderRow-specific attributes via the convention' do
      struct = Fortnox::Structs::OrderRow.new(article_number: '101', ordered_quantity: 7.0)
      expect(described_class.serialise(struct)).to include('OrderedQuantity' => 7.0)
    end

    it 'inherits HouseWork-prefixed overrides from DocumentRow' do
      struct = Fortnox::Structs::OrderRow.new(article_number: '101', housework: true)
      expect(described_class.serialise(struct)).to include('HouseWork' => true)
    end
  end
end
