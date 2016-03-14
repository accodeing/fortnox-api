require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Repository::Customer do
  include_context 'repository context'

  subject { described_class.new }

  it_behaves_like 'repositories', Fortnox::API::Model::Customer

  let( :find_id ){ 1 }
  let( :find_request ) do
    VCR.use_cassette( 'customers/find_id_1' ){ subject.find( find_id ) }
  end

  describe '.all' do
    let(:response) do
      VCR.use_cassette( 'customers/all' ){ subject.all }
    end

    specify 'returns correct number of records' do
      expect( response.size ).to be 1
    end

    specify 'returns correct class' do
      expect( response.first.class ).to be Fortnox::API::Model::Customer
    end
  end

  describe '.find' do
    specify 'returns correct class' do
      expect( find_request.class ).to be Fortnox::API::Model::Customer
    end

    specify 'returns correct Customer' do
      expect( find_request.customer_number.to_i ).to eq( find_id )
    end
  end

  describe '#save' do

    shared_examples_for 'save' do |attribute|
      specify 'record is saved' do
        send_request
        expect( model ).to be_saved
      end

      specify "include updated #{attribute.inspect}" do
        send_request
        expect( response['Customer'][attribute] ).to eql( updated_attribute )
      end
    end

    describe 'new' do
      include_examples 'save', 'Name' do
        let( :updated_attribute ){ 'A customer' }
        let( :model ) do
          Fortnox::API::Model::Customer.new( name: updated_attribute )
        end

        let( :send_request ) do
          VCR.use_cassette( 'customers/save_new' ){ subject.save( model ) }
        end

        let( :response ){ send_request }
      end
    end

    describe 'old (update existing)' do
      include_examples 'save', 'Name' do
        let( :updated_attribute ){ 'Updated customer' }
        let( :model ){ find_request.update( name: updated_attribute ) }

        let( :send_request ) do
          VCR.use_cassette( 'customers/save_old' ){ subject.save( model ) }
        end
        let( :response ){ send_request }
      end
    end
  end
end
