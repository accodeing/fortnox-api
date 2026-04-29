# frozen_string_literal: true

require 'spec_helper'

module FortnoxStructMapperTestStructs
  class Plain < Fortnox::Struct
    attribute? :name,       Fortnox::Types::Coercible::String.optional
    attribute? :test_value, Fortnox::Types::Coercible::String.optional
  end

  class WithAcronyms < Fortnox::Struct
    attribute? :name,            Fortnox::Types::Coercible::String.optional
    attribute? :id_key,          Fortnox::Types::Coercible::String.optional
    attribute? :computed_total,  Fortnox::Types::Coercible::Float.optional, :read_only
  end
end

module FortnoxStructMapperTestMappers
  class Plain < Fortnox::Mappers::Struct
    struct FortnoxStructMapperTestStructs::Plain
  end

  class WithAcronyms < Fortnox::Mappers::Struct
    struct    FortnoxStructMapperTestStructs::WithAcronyms
    overrides id_key: 'IDKey'
  end
end

RSpec.describe Fortnox::Mappers::Struct do
  describe '.parse' do
    it 'returns nil for nil input' do
      expect(FortnoxStructMapperTestMappers::Plain.parse(nil)).to be_nil
    end

    it 'parses PascalCase API keys via convention', :aggregate_failures do
      result = FortnoxStructMapperTestMappers::Plain.parse('Name' => 'hello', 'TestValue' => 'world')
      expect(result.name).to eq('hello')
      expect(result.test_value).to eq('world')
    end

    it 'uses overrides for keys the convention cannot derive' do
      result = FortnoxStructMapperTestMappers::WithAcronyms.parse('IDKey' => 'abc')
      expect(result.id_key).to eq('abc')
    end
  end

  describe '.serialise' do
    it 'returns nil for nil input' do
      expect(FortnoxStructMapperTestMappers::Plain.serialise(nil)).to be_nil
    end

    it 'serialises with PascalCase keys via convention' do
      struct = FortnoxStructMapperTestStructs::Plain.new(name: 'hello', test_value: 'world')
      expect(FortnoxStructMapperTestMappers::Plain.serialise(struct))
        .to eq('Name' => 'hello', 'TestValue' => 'world')
    end

    it 'applies overrides on serialisation' do
      struct = FortnoxStructMapperTestStructs::WithAcronyms.new(name: 'hello', id_key: 'abc')
      result = FortnoxStructMapperTestMappers::WithAcronyms.serialise(struct)
      expect(result).to include('IDKey' => 'abc')
    end

    it 'excludes read-only attributes' do
      struct = FortnoxStructMapperTestStructs::WithAcronyms.new(
        name: 'hello', id_key: 'abc', computed_total: 99.0
      )
      result = FortnoxStructMapperTestMappers::WithAcronyms.serialise(struct)
      expect(result).not_to have_key('ComputedTotal')
    end
  end
end
