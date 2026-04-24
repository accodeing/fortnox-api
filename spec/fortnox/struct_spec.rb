# frozen_string_literal: true

require 'spec_helper'

module FortnoxStructTestStructs
  class Simple < Fortnox::Struct
    include Fortnox::Types

    attr :name, Coercible::String.optional
    attr :test_value, Coercible::String.optional
  end

  class WithCustomKeys < Fortnox::Struct
    using RestEasy::Refinements
    include Fortnox::Types

    attr :name, Coercible::String.optional
    attr :test_id_key <=> 'TestIDKey', Coercible::String.optional
  end

  class WithReadOnly < Fortnox::Struct
    include Fortnox::Types

    attr :name, Coercible::String.optional
    attr :total, Coercible::Integer.optional, :read_only
  end
end

RSpec.describe Fortnox::Struct do
  describe '.attr' do
    it 'defines an optional attribute on the struct' do
      instance = FortnoxStructTestStructs::Simple.new(name: 'hello')
      expect(instance.name).to eq('hello')
    end

    it 'allows omitting optional attributes' do
      instance = FortnoxStructTestStructs::Simple.new
      expect(instance.name).to be_nil
    end
  end

  describe '.api_key_map' do
    it 'maps PascalCase API keys to snake_case model keys' do
      expect(FortnoxStructTestStructs::Simple.api_key_map).to include('Name' => :name, 'TestValue' => :test_value)
    end

    it 'uses custom key mappings when provided' do
      expect(FortnoxStructTestStructs::WithCustomKeys.api_key_map).to include('TestIDKey' => :test_id_key)
    end
  end

  describe '.model_key_map' do
    it 'maps snake_case model keys to PascalCase API keys' do
      expect(FortnoxStructTestStructs::Simple.model_key_map).to include(name: 'Name', test_value: 'TestValue')
    end

    it 'uses custom key mappings when provided' do
      expect(FortnoxStructTestStructs::WithCustomKeys.model_key_map).to include(test_id_key: 'TestIDKey')
    end
  end

  describe '.read_only_attributes' do
    it 'returns an empty list when no attributes are read-only' do
      expect(FortnoxStructTestStructs::Simple.read_only_attributes).to be_empty
    end

    it 'tracks attributes marked as read-only' do
      expect(FortnoxStructTestStructs::WithReadOnly.read_only_attributes).to eq([:total])
    end
  end

  describe '#to_api_hash' do
    it 'converts to a hash with PascalCase API keys' do
      struct = FortnoxStructTestStructs::Simple.new(name: 'hello', test_value: 'world')
      expect(struct.to_api_hash).to include('Name' => 'hello', 'TestValue' => 'world')
    end

    it 'uses custom key mappings', :aggregate_failures do
      struct = FortnoxStructTestStructs::WithCustomKeys.new(name: 'hello', test_id_key: 'value')
      result = struct.to_api_hash
      expect(result.keys).to contain_exactly('Name', 'TestIDKey')
      expect(result).to include('TestIDKey' => 'value')
    end

    it 'excludes read-only attributes', :aggregate_failures do
      struct = FortnoxStructTestStructs::WithReadOnly.new(name: 'hello', total: 100)
      result = struct.to_api_hash
      expect(result).to include('Name' => 'hello')
      expect(result).not_to have_key('Total')
    end
  end

  describe 'transform_keys' do
    it 'parses PascalCase keys from API responses', :aggregate_failures do
      instance = FortnoxStructTestStructs::Simple.new('Name' => 'hello', 'TestValue' => 'world')
      expect(instance.name).to eq('hello')
      expect(instance.test_value).to eq('world')
    end
  end

  describe 'inheritance' do
    it 'does not share api_key_map between subclasses' do
      expect(FortnoxStructTestStructs::Simple.api_key_map).not_to have_key('TestIDKey')
    end

    it 'does not share model_key_map between subclasses' do
      expect(FortnoxStructTestStructs::Simple.model_key_map).not_to have_key(:test_id_key)
    end

    it 'does not share read_only_attributes between subclasses' do
      expect(FortnoxStructTestStructs::Simple.read_only_attributes).to be_empty
    end
  end
end
