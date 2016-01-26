require 'spec_helper'
require 'fortnox/api/models/row/validator'
require 'fortnox/api/models/row/entity'

describe Fortnox::API::Validators::Row do
  let( :entity_class ){ Fortnox::API::Entities::Row }

  subject { described_class.new( entity ) }

  describe '.validate Row with' do

    context 'required attributes' do
      let( :entity ){ entity_class.new }

      it { is_expected.to validate_true( entity ) }
    end

    context 'invalid account number' do
      let( :too_large_account_number ){ 12345 }
      let( :entity ) do
        entity_class.new( account_number: too_large_account_number )
      end

      it { is_expected.to validate_false( entity ) }
      it { is_expected.to include_error_for( :account_number, 1 ) }
    end
  end
end
