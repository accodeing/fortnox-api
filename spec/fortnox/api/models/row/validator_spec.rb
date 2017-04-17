require 'spec_helper'
require 'fortnox/api/models/row/validator'
require 'fortnox/api/models/row/entity'

describe Fortnox::API::Validators::Row do
  let( :row_klass ){ Fortnox::API::Entities::Row }

  describe '.validate Row with' do
    context 'required attributes' do
      let( :row ){ row_klass.new }

      it { is_expected.to validate_true( row ) }
    end

    context 'invalid account number' do
      let( :too_large_account_number ){ 12345 }
      let( :row ){ row_klass.new( account_number: too_large_account_number ) }

      it do
        described_class.validate( row )
        puts row.account_number
        expect( described_class.violations.inspect ).to include( 'account_number' )
      end

      it { is_expected.to validate_false( row ) }
      it { is_expected.to include_violation_on( row, 'account_number' ) }
    end
  end
end
