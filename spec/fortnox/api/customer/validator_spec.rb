require 'spec_helper'

describe Fortnox::API::Customer::Validator do

  describe 'basic creation with only name' do
    let( :customer ){ Fortnox::API::Customer.new( name: 'Test' ) }
    let( :validator ){ Fortnox::API::Customer::Validator }
    subject { validator.validate( customer ) }
    it { should be_true }
  end

  describe 'creation sales_account out of range' do
    let( :customer ){ Fortnox::API::Customer.new( sales_account: 99999 ) }
    let( :validator ){ Fortnox::API::Customer::Validator }
    subject { validator.validate( customer ) }
    it { should be_false }
  end

  describe 'creation sales_account out of range message' do
    let( :customer ){ Fortnox::API::Customer.new( sales_account: 99999 ) }
    let( :validator ){ Fortnox::API::Customer::Validator }
    subject { validator.validate( customer ); validator.violations.inspect }
    it { should include 'sales_account' }
  end

end
