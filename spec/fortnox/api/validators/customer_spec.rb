require 'spec_helper'
require 'fortnox/api/validators/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Validator::Customer do
  subject{ described_class.new }

  describe '.validate' do
    context 'Customer with valid, simple attributes' do
      let( :customer ){ Fortnox::API::Model::Customer.new( name: 'Test' ) }

      it 'is valid' do
        expect( subject.validate( customer )).to eql( true )
      end
    end

    context 'Customer with invalid sales_account' do
      let( :customer ){ Fortnox::API::Model::Customer.new( name: 'Test', sales_account: 99999 ) }

      it 'is invalid' do
        expect( subject.validate( customer )).to eql( false )
      end

      it 'includes "sales_account" in violations' do
        subject.validate( customer )

        expect( subject.violations.any?{ |v| v.rule.attribute_name == :sales_account }).to eql( true )
        expect( subject.violations.any?{ |v| v.rule.type == :inclusion }).to eql( true )
      end
    end
  end

end
