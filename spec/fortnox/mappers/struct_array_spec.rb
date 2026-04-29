# frozen_string_literal: true

require 'spec_helper'

module FortnoxArrayMapperTestStructs
  class Simple < Fortnox::Struct
    attribute? :name, Fortnox::Types::Coercible::String.optional
  end
end

class FortnoxArrayMapperTestMapper < Fortnox::Mappers::Struct
  struct FortnoxArrayMapperTestStructs::Simple
end

RSpec.describe Fortnox::Mappers::StructArray do
  let(:mapper) { described_class.for(FortnoxArrayMapperTestMapper) }

  describe '.parse' do
    it 'returns empty array for nil input' do
      expect(mapper.parse(nil)).to eq([])
    end

    it 'raises an error for non-array input' do
      expect { mapper.parse('not an array') }.to raise_error(Fortnox::AttributeError)
    end

    it 'delegates each element to the mapper', :aggregate_failures do
      result = mapper.parse([{ 'Name' => 'first' }, { 'Name' => 'second' }])
      expect(result.size).to eq(2)
      expect(result.first.name).to eq('first')
      expect(result.last.name).to eq('second')
    end
  end

  describe '.serialise' do
    it 'returns empty array for nil input' do
      expect(mapper.serialise(nil)).to eq([])
    end

    it 'delegates each element to the mapper' do
      struct = FortnoxArrayMapperTestStructs::Simple.new(name: 'hello')
      result = mapper.serialise([struct])
      expect(result).to eq([FortnoxArrayMapperTestMapper.serialise(struct)])
    end
  end
end
