# frozen_string_literal: true

require 'spec_helper'

module FortnoxMapperTestStructs
  class Simple < Fortnox::Struct
    attr :name, Fortnox::Types::Coercible::String.optional
  end
end

RSpec.describe Fortnox::Mappers::Struct do
  let(:parser) { described_class.for(FortnoxMapperTestStructs::Simple) }

  describe '.parse' do
    it 'creates a struct from a hash' do
      result = parser.parse('Name' => 'hello')
      expect(result.name).to eq('hello')
    end
  end

  describe '.serialise' do
    it 'returns nil for nil input' do
      expect(parser.serialise(nil)).to be_nil
    end

    it 'delegates to the struct' do
      struct = FortnoxMapperTestStructs::Simple.new(name: 'hello')
      expect(parser.serialise(struct)).to eq(struct.to_api_hash)
    end
  end
end
