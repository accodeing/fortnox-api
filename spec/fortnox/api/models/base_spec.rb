require 'spec_helper'
require 'fortnox/api/models/base'

describe Fortnox::API::Model::Base do
  using_test_classes do
    class NestedEntity < Fortnox::API::Model::Base
      attribute :string, String
    end

    class Entity < Fortnox::API::Model::Base
      attribute :private, String, writer: :private
      attribute :string, String
      attribute :number, Integer, default: 42
      attribute :nested_entity, NestedEntity
      attribute :nested_entities, Array[NestedEntity]
    end
  end

  describe '#new' do
    context 'with basic attribute' do
      subject{ Entity.new( string: 'Test' ) }

      it{ is_expected.to be_a Entity }
      it{ is_expected.to be_new }
      it{ is_expected.to_not be_saved }
    end
  end

  describe '#update' do
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

  describe '#to_hash' do
    let( :string ){ 'Some string' }

    subject{ model.to_hash }

    shared_examples 'attributes hash' do
      let( :default_number ){ 42 }
      it{ is_expected.to include( string: string ) }
      it{ is_expected.to include( private: nil ) }
      it{ is_expected.to include( number: default_number ) }
    end

    context 'without nested models' do
      let( :model ){ Entity.new( string: string ) }

      include_examples 'attributes hash'
    end

    context 'with nested models' do
      let( :nested_entities_0_string ){ 'Nested 0' }
      let( :nested_entities_1_string ){ 'Nested 1' }
      let( :nested_string ){ 'Nested String' }
      let( :model ) do
        nested_entities_0 = NestedEntity.new( string: nested_entities_0_string )
        nested_entities_1 = NestedEntity.new( string: nested_entities_1_string )
        nested_entity = NestedEntity.new( string: nested_string )
        Entity.new( string: string,
                    nested_entities: [nested_entities_0, nested_entities_1],
                    nested_entity: nested_entity )
      end

      include_examples 'attributes hash'

      it 'turns nested entity into hash' do
        expect( subject[:nested_entity] ).to eq( { string: nested_string } )
      end

      describe 'in array' do
        it 'turns first nested attribute to hash' do
          hash = { string: nested_entities_0_string }
          expect( subject[:nested_entities][0] ).to eq( hash )
        end

        it 'turns second nested attribute to hash' do
          hash = { string: nested_entities_1_string }
          expect( subject[:nested_entities][1] ).to eq( hash )
        end
      end
    end
  end
end
