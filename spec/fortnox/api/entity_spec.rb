require 'spec_helper'

class TestEntity < Fortnox::API::Entity
  attribute :private, String, writer: :private
  attribute :string, String
  attribute :number, Integer, default: 42
end

describe Fortnox::API::Entity do

  describe 'basic creation with only name' do
    let( :test ){ TestEntity.new( string: 'Test' ) }
    subject { test.class }
    it { should == TestEntity }
  end

  describe 'updateing attribute with `update`' do
    context 'to a different value' do
      let( :original ){ TestEntity.new( string: 'Test' ) }
      let( :variant ){ original.update( string: 'Variant' ) }
      subject { variant.eql? original }
      it { should be_false }
    end

    context 'to the same value' do
      let( :original ){ TestEntity.new( string: 'Test' ) }
      let( :variant ){ original.update( string: 'Test' ) }
      subject { variant.eql? original }
      it { should be_true }
    end
  end

  describe 'setting attribute with `attr=`' do
    context 'to a different value, object equality' do
      let( :original ){ TestEntity.new( string: 'Test' ) }
      subject { original.string = 'Variant' }
      it { should be_eql original }
    end

    context 'to a different value, object class' do
      let( :original ){ TestEntity.new( string: 'Test' ) }
      let( :variant ){ original.string=('Variant') }
      subject { variant.class }
      it { should == TestEntity }
    end

    context 'to the same value, object equality' do
      let( :original ){ TestEntity.new( string: 'Test' ) }
      subject{ original[:string]='Test' }
      it { shouldnt be_eql original }
    end

    context 'to the same value, object class' do
      let( :original ){ TestEntity.new( string: 'Test' ) }
      let( :variant ){ original.string=('Test'); }
      subject { variant.class }
      it { should == TestEntity }
    end
  end

end
