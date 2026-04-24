# frozen_string_literal: true

require 'spec_helper'

module FortnoxArrayMapperTestStructs
  class Simple < Fortnox::Struct
    attr :name, Fortnox::Types::Coercible::String.optional
  end
end

RSpec.describe Fortnox::Mappers::StructArray do
  let(:parser) { described_class.for(FortnoxArrayMapperTestStructs::Simple) }
  let(:struct_parser) { Fortnox::Mappers::Struct.for(FortnoxArrayMapperTestStructs::Simple) }

  describe '.parse' do
    it 'returns empty array for nil input' do
      expect(parser.parse(nil)).to eq([])
    end

    it 'raises an error for non-array input' do
      expect { parser.parse('not an array') }.to raise_error(Fortnox::AttributeError)
    end

    it 'delegates each element to the struct parser', :aggregate_failures do
      result = parser.parse([{ 'Name' => 'first' }, { 'Name' => 'second' }])
      expect(result.size).to eq(2)
      expect(result.first.name).to eq('first')
      expect(result.last.name).to eq('second')
    end
  end

  describe '.serialise' do
    it 'returns empty array for nil input' do
      expect(parser.serialise(nil)).to eq([])
    end

    it 'delegates each element to the struct parser' do
      struct = FortnoxArrayMapperTestStructs::Simple.new(name: 'hello')
      result = parser.serialise([struct])
      expect(result).to eq([struct_parser.serialise(struct)])
    end
  end
end
