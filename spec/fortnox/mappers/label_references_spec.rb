# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Mappers::LabelReferences do
  describe '.parse' do
    it 'returns an empty array for nil' do
      expect(described_class.parse(nil)).to eq([])
    end

    it 'returns an empty array for non-array input' do
      expect(described_class.parse('not an array')).to eq([])
    end

    it 'maps each hash to a Fortnox::Label', :aggregate_failures do
      result = described_class.parse([{ 'Id' => 1, 'Description' => 'first' }])
      expect(result.size).to eq(1)
      expect(result.first).to be_a(Fortnox::Label)
      expect(result.first.model.id).to eq(1)
      expect(result.first.model.description).to eq('first')
    end
  end

  describe '.serialise' do
    it 'returns an empty array for nil' do
      expect(described_class.serialise(nil)).to eq([])
    end

    it 'returns an empty array for non-array input' do
      expect(described_class.serialise('not an array')).to eq([])
    end

    it 'serialises each label to a hash with Id only' do
      label = Fortnox::Label.stub(id: 42, description: 'shipped')
      expect(described_class.serialise([label])).to eq([{ 'Id' => 42 }])
    end
  end
end
