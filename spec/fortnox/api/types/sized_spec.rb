require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types::Sized do

  shared_examples_for 'Sized Types' do
    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end
  end

  shared_examples_for 'equals input' do |input|
    subject{ described_class[ input ] }
    it{ is_expected.to eq input }
  end

  shared_examples_for 'raises ConstraintError' do |input|
    subject{ ->{ described_class[ input ] } }
    it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
  end

  describe 'String' do
    let( :described_class ){ Fortnox::API::Types::Sized::String[ 5 ] }

    it_behaves_like 'Sized Types'

    context 'created with empty string' do
      include_examples 'equals input', ''
    end

    context 'created with fewer characters than the limit' do
      include_examples 'equals input', 'Test'
    end

    context 'created with more characters than the limit' do
      include_examples 'raises ConstraintError', 'Too many'
    end
  end

  describe 'Float' do
    max = 100.0
    let( :described_class ){ Fortnox::API::Types::Sized::Float[ 0.0, max ] }

    it_behaves_like 'Sized Types'

    context 'created with value below the lower limit' do
      include_examples 'raises ConstraintError', -1.0
    end

    context 'created with value at the lower limit' do
      include_examples 'equals input', 0.0
    end

    context 'created with valid number' do
      include_examples 'equals input', 50.0
    end

    context 'created with value at the upper limit' do
      include_examples 'equals input', max
    end

    context 'created with value above the upper limit' do
      include_examples 'raises ConstraintError', max + 0.1
    end
  end

  describe 'Integer' do
    max = 100
    let( :described_class ){ Fortnox::API::Types::Sized::Integer[ 0, max ] }

    it_behaves_like 'Sized Types'

    context 'created with value below the lower limit' do
      include_examples 'raises ConstraintError', -1
    end

    context 'created with value at the lower limit' do
      include_examples 'equals input', 0
    end

    context 'created with valid number' do
      include_examples 'equals input', 50
    end

    context 'created with value at the upper limit' do
      include_examples 'equals input', max
    end

    context 'created with value above the upper limit' do
      include_examples 'raises ConstraintError', max + 1
    end
  end

end
