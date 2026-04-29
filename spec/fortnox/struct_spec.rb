# frozen_string_literal: true

require 'spec_helper'

module FortnoxStructTestStructs
  class Simple < Fortnox::Struct
    attribute? :name, Fortnox::Types::Coercible::String.optional
    attribute? :count, Fortnox::Types::Coercible::Integer.optional
  end

  class WithReadOnly < Fortnox::Struct
    attribute? :name, Fortnox::Types::Coercible::String.optional
    attribute? :total, Fortnox::Types::Coercible::Integer.optional, :read_only
  end

  class ChildWithReadOnly < WithReadOnly
    attribute? :subtotal, Fortnox::Types::Coercible::Integer.optional, :read_only
  end

  class WithRequiredReadOnly < Fortnox::Struct
    attribute :name, Fortnox::Types::Strict::String
    attribute :total, Fortnox::Types::Strict::Integer, :read_only
  end
end

RSpec.describe Fortnox::Struct do
  describe 'attribute?' do
    it 'defines an optional attribute on the struct' do
      instance = FortnoxStructTestStructs::Simple.new(name: 'hello')
      expect(instance.name).to eq('hello')
    end

    it 'allows omitting optional attributes' do
      instance = FortnoxStructTestStructs::Simple.new
      expect(instance.name).to be_nil
    end
  end

  describe '.read_only_attributes' do
    it 'returns an empty list when no attributes are read-only' do
      expect(FortnoxStructTestStructs::Simple.read_only_attributes).to be_empty
    end

    it 'tracks optional attributes marked as read-only' do
      expect(FortnoxStructTestStructs::WithReadOnly.read_only_attributes).to eq([:total])
    end

    it 'tracks required attributes marked as read-only' do
      expect(FortnoxStructTestStructs::WithRequiredReadOnly.read_only_attributes).to eq([:total])
    end

    it 'inherits read-only attributes from parent without leaking back', :aggregate_failures do
      expect(FortnoxStructTestStructs::ChildWithReadOnly.read_only_attributes).to contain_exactly(:total, :subtotal)
      expect(FortnoxStructTestStructs::WithReadOnly.read_only_attributes).to eq([:total])
    end
  end
end
