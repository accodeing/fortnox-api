# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types::Sized do
  shared_examples_for 'Sized Types' do
    context 'when created with nil' do
      subject { klass[nil] }

      it { is_expected.to be_nil }
    end
  end

  describe 'String' do
    max_size = 5
    let(:klass) { described_class::String[max_size] }

    it_behaves_like 'Sized Types'

    context 'when created with empty string' do
      include_examples 'equals input', ''
    end

    context 'when created with fewer characters than the limit' do
      include_examples 'equals input', 'a' * (max_size - 1)
    end

    context 'when created with valid string' do
      include_examples 'equals input', 'a' * max_size
    end

    context 'when created with more characters than the limit' do
      include_examples 'raises ConstraintError', 'a' * (max_size + 1)
    end
  end

  shared_examples_for 'Sized Numeric' do |type, min, max, step|
    let(:klass) { described_class.const_get(type)[min, max] }

    it_behaves_like 'Sized Types'

    context 'when created with value below the lower limit' do
      include_examples 'raises ConstraintError', min - step
    end

    context 'when created with value at the lower limit' do
      include_examples 'equals input', min
    end

    context 'when created with valid number near lower limit' do
      include_examples 'equals input', min + step
    end

    context 'when created with valid number near upper limit' do
      include_examples 'equals input', max - step
    end

    context 'when created with value at the upper limit' do
      include_examples 'equals input', max
    end

    context 'when created with value above the upper limit' do
      include_examples 'raises ConstraintError', max + step
    end
  end

  describe 'Float' do
    it_behaves_like 'Sized Numeric', 'Float', 0.0, 100.0, 0.1
  end

  describe 'Integer' do
    it_behaves_like 'Sized Numeric', 'Integer', 0, 100, 1
  end
end
