# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Mappers::Date do
  describe '.parse' do
    it 'returns nil for nil' do
      expect(described_class.parse(nil)).to be_nil
    end

    it 'returns nil for an empty string' do
      expect(described_class.parse('')).to be_nil
    end

    it 'parses a YYYY-MM-DD string into a Date' do
      expect(described_class.parse('2025-01-15')).to eq(Date.new(2025, 1, 15))
    end
  end

  describe '.serialise' do
    it 'returns nil for nil' do
      expect(described_class.serialise(nil)).to be_nil
    end

    it 'formats a Date as YYYY-MM-DD' do
      expect(described_class.serialise(Date.new(2025, 1, 15))).to eq('2025-01-15')
    end
  end

  describe 'round-trip' do
    it 'parses then serialises to the same string' do
      expect(described_class.serialise(described_class.parse('2025-01-15'))).to eq('2025-01-15')
    end
  end
end
