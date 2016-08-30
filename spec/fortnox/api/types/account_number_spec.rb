require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types do
  describe 'AccountNumber' do
    let( :described_class ){ Fortnox::API::Types::AccountNumber }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with empty string' do
      let( :input ){ '' }
      subject{ ->{ described_class[ input ] } }
      it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
    end

    context 'created with valid number' do
      let( :input ){ 1234 }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with a too large number' do
      let( :input ){ 10000 }
      subject{ ->{ described_class[ input ] } }
      it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
    end

    context 'created with a negative number' do
      let( :input ){ -1 }
      subject{ ->{ described_class[ input ] } }
      it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
    end
  end
end
