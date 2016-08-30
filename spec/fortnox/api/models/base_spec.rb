require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/types'

describe Fortnox::API::Model::Base do
  using_test_classes do
    class Entity < Fortnox::API::Model::Base
      attribute :private, Fortnox::API::Types::String.with( read_only: true )
      attribute :string, Fortnox::API::Types::String
      attribute :number, Fortnox::API::Types::Nullable::Integer
    end
  end

  describe '.new' do
    context 'with basic attribute' do
      subject{ Entity.new( string: 'Test' ) }

      it{ is_expected.to be_a Entity }
      it{ is_expected.to be_new }
      it{ is_expected.to_not be_saved }
    end
  end

  describe '.update' do
    let(:original){ Entity.new( string: 'Test' ) }

    context 'with new, simple value' do
      subject{ original.update( string: 'Variant' ) }

      it 'returns a new object' do
        is_expected.to_not eql( original )
      end

      it 'returns a object of the same class' do
        expect( subject.class ).to eql( original.class )
      end

      it 'returns a object with the new value' do
        expect( subject.string ).to eql( 'Variant' )
      end

      it{ is_expected.to be_new }
      it{ is_expected.to_not be_saved }
    end

    context 'with the same, simple value' do
      subject{ original.update( string: 'Test' ) }

      it 'returns the same object' do
        is_expected.to eql( original )
      end

      it 'returns a object with the same value' do
        expect( subject.string ).to eql( 'Test' )
      end

      it{ is_expected.to be_new }
      it{ is_expected.to_not be_saved }
    end

    context 'a saved entity' do
      let( :saved_entry ){ Entity.new( string: 'Saved', new: false, unsaved: false) }

      subject{ saved_entry.update( string: 'Updated' ) }

      before do
        expect(saved_entry).to_not be_new
        expect(saved_entry).to be_saved
      end

      specify{ expect(subject.string).to eq( 'Updated' ) }
      it{ is_expected.to_not be_new }
      it{ is_expected.to_not be_saved }
    end
  end

end
