require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/types'

describe Fortnox::API::Model::Base do
  using_test_classes do
    class Entity < Fortnox::API::Model::Base
      attribute :private, Fortnox::API::Types::String.with( read_only: true )
      attribute :string, Fortnox::API::Types::Required::String
      attribute :number, Fortnox::API::Types::Nullable::Integer
      attribute :account, Fortnox::API::Types::AccountNumber
    end
  end

  describe '.new' do
    context 'with basic attribute' do
      subject{ Entity.new( string: 'Test' ) }

      it{ is_expected.to be_a Entity }
      it{ is_expected.to be_new }
      it{ is_expected.not_to be_saved }
    end

    context 'without required attribute' do
      subject{ ->{ Entity.new({}) }}

      it{ is_expected.to raise_error Fortnox::API::Exception }
      it{ is_expected.to raise_error Fortnox::API::MissingAttributeError }
      it{ is_expected.to raise_error Fortnox::API::MissingAttributeError, /Missing attribute :string/ }
    end

    context 'with invalid attribute value' do
      subject{ ->{ Entity.new({ string: 'Test', account: 13337 }) }}

      it{ is_expected.to raise_error Fortnox::API::Exception }
      it{ is_expected.to raise_error Fortnox::API::InvalidAttributeValueError }
      it{ is_expected.to raise_error Fortnox::API::InvalidAttributeValueError, /invalid type for :account/ }
    end
  end

  describe '.update' do
    let(:original){ Entity.new( string: 'Test' ) }

    context 'with new, simple value' do
      subject{ updated_model }

      let(:updated_model){ original.update( string: 'Variant' ) }

      it{ is_expected.to be_new }
      it{ is_expected.not_to be_saved }

      it 'returns a new object' do
        is_expected.not_to eql( original )
      end

      describe 'updated attribute' do
        subject{ updated_model.string }
        it{ is_expected.to eql( 'Variant' ) }
      end

      describe 'returned class' do
        subject{ updated_model.class }
        it{ is_expected.to eql( original.class ) }
      end
    end

    context 'with the same, simple value' do
      subject( :updated_model ){ original.update( string: 'Test' ) }

      it 'returns the same object' do
        is_expected.to eql( original )
      end

      it 'returns a object with the same value' do
        expect( updated_model.string ).to eql( 'Test' )
      end

      it{ is_expected.to be_new }
      it{ is_expected.not_to be_saved }
    end

    context 'a saved entity' do
      subject( :updated_entry ){ saved_entry.update( string: 'Updated' ) }

      let( :saved_entry ){ Entity.new( string: 'Saved', new: false, unsaved: false) }

      before do
        expect(saved_entry).not_to be_new
        expect(saved_entry).to be_saved
      end

      specify{ expect(updated_entry.string).to eq( 'Updated' ) }
      it{ is_expected.not_to be_new }
      it{ is_expected.not_to be_saved }
    end
  end

end
