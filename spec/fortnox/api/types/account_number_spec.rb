# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types do
  let(:klass) { Fortnox::API::Types::AccountNumber }

  describe 'AccountNumber' do
    context 'when created with nil' do
      subject { klass[nil] }

      it { is_expected.to be_nil }
    end

    context 'when created with empty string' do
      include_examples 'raises ConstraintError', ''
    end

    context 'when created with valid number' do
      include_examples 'equals input', 1234
    end

    context 'when created with a too large number' do
      include_examples 'raises ConstraintError', 10_000
    end

    context 'when created with a negative number' do
      include_examples 'raises ConstraintError', -1
    end
  end
end
