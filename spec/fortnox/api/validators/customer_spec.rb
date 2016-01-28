require 'spec_helper'
require 'fortnox/api/validators/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Validator::Customer do
  let( :validator_class ){ Fortnox::API::Validator::Customer }

  describe '.validate' do
    context 'Customer with valid, simple attributes' do
      let( :customer ){ Fortnox::API::Model::Customer.new( name: 'Test' ) }
      let( :validator ){ Fortnox::API::Validator::Customer.new( customer ) }

      it 'is valid' do
        expect( validator.valid? ).to eql( true )
      end
    end

    context 'Customer with invalid sales_account' do
      let( :customer ){ Fortnox::API::Model::Customer.new( name: 'Test', sales_account: 99999 ) }
      let( :validator ){ Fortnox::API::Validator::Customer.new( customer ) }

      it 'is invalid' do
        expect( validator.valid? ).to eql( false )
      end

      it 'includes "sales_account" in violations' do
        validator.valid?

        expect( validator.errors.for( :sales_account ).length ).to eql( 1 )
      end
    end
  end

end
