require 'spec_helper'
require 'fortnox/api/models/customer/validator'
require 'fortnox/api/models/customer/entity'

describe Fortnox::API::Validators::Customer do

  describe '.validate' do
    context 'Customer with valid, simple attributes' do
      it 'is valid' do
        customer = Fortnox::API::Enteties::Customer.new( name: 'Test' )
        validator = Fortnox::API::Validators::Customer

        expect( validator.validate( customer )).to eql( true )
      end
    end

    context 'Customer with invalid sales_account' do

      let( :customer ){ Fortnox::API::Enteties::Customer.new( sales_account: 99999 )}
      let( :validator ){ Fortnox::API::Validators::Customer }

      it 'is invalid' do
        expect( validator.validate( customer )).to eql( false )
      end

      it 'includes "sales_account" in violations' do
        validator.validate( customer )

        expect( validator.violations.inspect ).to include( 'sales_account' )
      end
    end
  end

end
