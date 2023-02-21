# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/types'

describe Fortnox::API::Model::Base do
  let(:entity_class) do
    Class.new(Fortnox::API::Model::Base) do
      attribute :private, Fortnox::API::Types::String.is(:read_only)
      attribute :string, Fortnox::API::Types::Required::String
      attribute :number, Fortnox::API::Types::Nullable::Integer
      attribute :account, Fortnox::API::Types::AccountNumber
    end
  end

  describe '.new' do
    context 'with basic attribute' do
      subject { entity_class.new(string: 'Test') }

      it { is_expected.to be_a entity_class }
      it { is_expected.to be_new }
      it { is_expected.not_to be_saved }
    end

    context 'without required attribute' do
      it do
        expect do
          entity_class.new({})
        end.to raise_error Fortnox::API::MissingAttributeError, /Missing attribute :string/
      end
    end

    context 'with invalid attribute value' do
      it do
        expect do
          entity_class.new(string: 'Test', account: 13_337)
        end.to raise_error Fortnox::API::AttributeError, /invalid type for :account/
      end
    end
  end

  describe '.update' do
    let(:original) { entity_class.new(string: 'Test') }

    context 'with new, simple value' do
      subject(:updated_model) { original.update(string: 'Variant') }

      it { is_expected.to be_new }
      it { is_expected.not_to be_saved }

      it 'returns a new object' do
        expect(updated_model).not_to eql(original)
      end

      describe 'updated attribute' do
        subject { updated_model.string }

        it { is_expected.to eql('Variant') }
      end

      describe 'returned class' do
        subject { updated_model.class }

        it { is_expected.to eql(original.class) }
      end
    end

    context 'with the same, simple value' do
      subject(:updated_model) { original.update(string: 'Test') }

      it 'returns the same object' do
        expect(updated_model).to eql(original)
      end

      it 'returns a object with the same value' do
        expect(updated_model.string).to eql('Test')
      end

      it { is_expected.to be_new }
      it { is_expected.not_to be_saved }
    end

    context 'when updating a saved entity' do
      let(:updated_entity) do
        saved_entity = entity_class.new(string: 'Saved', new: false, unsaved: false)
        saved_entity.update(string: 'Updated')
      end

      describe 'updated entity' do
        subject { updated_entity }

        it { is_expected.not_to be_saved }
        it { is_expected.not_to be_new }
      end

      describe 'updated attribute value' do
        subject { updated_entity.string }

        it { is_expected.to eq('Updated') }
      end
    end

    context 'when updating a saved entity with nil values' do
      subject(:updated_entity) { original.update(number: nil) }

      let(:original) { entity_class.new(string: 'Saved', new: false, unsaved: false) }

      it 'returns the same object' do
        expect(updated_entity).to eql(original)
      end

      it { is_expected.not_to be_new }
      it { is_expected.to be_saved }
    end
  end
end
