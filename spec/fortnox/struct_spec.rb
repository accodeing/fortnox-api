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

  class WithBool < Fortnox::Struct
    attribute? :flag, Fortnox::Types::CoercibleBool.optional
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

  describe 'error translation' do
    it 'raises a Fortnox error rather than leaking Dry::Struct::Error' do
      expect { FortnoxStructTestStructs::Simple.new(count: 'not-a-number') }
        .to raise_error(Fortnox::ConstraintError)
    end

    it 'is caught by a rescue on the shared attribute-error superclass' do
      expect { FortnoxStructTestStructs::Simple.new(count: 'not-a-number') }
        .to raise_error(Fortnox::AttributeError)
    end

    it 'identifies the offending attribute and value', :aggregate_failures do
      expect { FortnoxStructTestStructs::Simple.new(count: 'not-a-number') }
        .to raise_error(Fortnox::ConstraintError) { |error|
          expect(error.attribute_name).to eq(:count)
          expect(error.value).to eq('not-a-number')
        }
    end

    it 'reports the failure the same way a resource attribute does' do
      expect { FortnoxStructTestStructs::WithBool.new(flag: 'maybe') }
        .to raise_error(Fortnox::ConstraintError, "Attribute 'flag': maybe cannot be coerced to false")
    end

    it 'still builds structs when every attribute is omitted' do
      expect(FortnoxStructTestStructs::Simple.new.name).to be_nil
    end
  end

  describe 'boolean coercion' do
    # Resource attributes are typed params.bool by rest-easy, so struct
    # attributes have to coerce identically or the same params hash behaves
    # differently depending on nesting depth.
    {
      'true' => true, 'yes' => true, '1' => true, 'on' => true,
      'false' => false, 'no' => false, '0' => false, 'off' => false
    }.each do |input, expected|
      it "coerces #{input.inspect} to #{expected}" do
        expect(FortnoxStructTestStructs::WithBool.new(flag: input).flag).to eq(expected)
      end
    end

    it 'leaves an actual boolean alone' do
      expect(FortnoxStructTestStructs::WithBool.new(flag: true).flag).to be(true)
    end

    it 'still allows nil' do
      expect(FortnoxStructTestStructs::WithBool.new(flag: nil).flag).to be_nil
    end

    it 'rejects a string that is not a boolean spelling' do
      expect { FortnoxStructTestStructs::WithBool.new(flag: 'maybe') }
        .to raise_error(Fortnox::ConstraintError)
    end

    it 'coerces nested rows built from string params' do
      order = Fortnox::Order.stub(
        customer_number: '1',
        order_rows: [{ article_number: '101', housework: 'true' }]
      )

      expect(order.order_rows.first.housework).to be(true)
    end
  end
end
