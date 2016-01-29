require 'spec_helper'
require 'fortnox/api/validators/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Validator::Customer do
  let( :validator ){ Fortnox::API::Validator::Customer }

  describe '.validate' do
    context 'Customer with valid, simple attributes' do
      let( :customer ){ Fortnox::API::Model::Customer.new( name: 'Test' ) }

      it 'is valid' do
        expect( validator.validate( customer )).to eql( true )
      end
    end

    context 'Customer with invalid sales_account' do
      let( :customer ){ Fortnox::API::Model::Customer.new( name: 'Test', sales_account: 99999 ) }

      it 'is invalid' do
        expect( validator.validate( customer )).to eql( false )
      end

      it 'includes "sales_account" in violations' do
        validator.validate( customer )

        expect( validator.violations.any?{|v| v.rule.attribute_name == :sales_account }).to eql( true )
        expect( validator.violations.any?{|v| v.rule.type == :inclusion }).to eql( true )
      end
    end
  end

end
