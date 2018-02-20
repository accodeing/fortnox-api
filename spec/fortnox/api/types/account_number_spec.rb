# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types do
  let(:klass) { Fortnox::API::Types::AccountNumber }

  context 'AccountNumber created with nil' do
    subject { klass[nil] }

    it { is_expected.to be_nil }
  end

  context 'AccountNumber created with empty string' do
    include_examples 'raises ConstraintError', ''
  end

  context 'AccountNumber created with valid number' do
    include_examples 'equals input', 1234
  end

  context 'AccountNumber created with a too large number' do
    include_examples 'raises ConstraintError', 10_000
  end

  context 'AccountNumber created with a negative number' do
    include_examples 'raises ConstraintError', -1
  end
end
