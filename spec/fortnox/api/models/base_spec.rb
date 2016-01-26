require 'spec_helper'
require 'fortnox/api/models/entity/base'

class TestEntity < Fortnox::API::Entities::Base
  attribute :private, String, writer: :private
  attribute :string, String
  attribute :number, Integer, default: 42
end

describe Fortnox::API::Entities::Base do
  let(:original){ TestEntity.new( string: 'Test' ) }

  describe '.new' do
    context 'with basic attribute' do
      it 'works' do
        test = TestEntity.new( string: 'Test' )

        expect( test.class ).to eql( TestEntity )
      end
    end
  end

  describe '.update' do
    context 'with new, simple value' do
      let(:variant){ original.update( string: 'Variant' ) }

      it 'returns a new object' do
        expect( variant ).to_not eql( original )
      end

      it 'returns a object of the same class' do
        expect( variant.class ).to eql( original.class )
      end

      it 'returns a object with the new value' do
        expect( variant.string ).to eql( 'Variant' )
      end
    end

    context 'with the same, simple value' do
      let(:variant){ original.update( string: 'Test' ) }

      it 'returns the same object' do
        expect( variant ).to eql( original )
      end

      it 'returns a object with the same value' do
        expect( variant.string ).to eql( 'Test' )
      end
    end
  end

end
