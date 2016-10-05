require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types do
  describe 'AccountNumber' do
    let( :described_class ){ Fortnox::API::Types::AccountNumber }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with empty string' do
      include_examples 'raises ConstraintError', ''
    end

    context 'created with valid number' do
      include_examples 'equals input', 1234
    end

    context 'created with a too large number' do
      include_examples 'raises ConstraintError', 10000
    end

    context 'created with a negative number' do
      include_examples 'raises ConstraintError', -1
    end
  end
end
