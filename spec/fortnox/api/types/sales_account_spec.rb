# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types do
  let(:klass) { Fortnox::API::Types::SalesAccount }

  describe 'SalesAccount' do
    context 'when created with nil' do
      subject { klass[nil] }

      it { is_expected.to be_nil }
    end

    context 'when created with empty string' do
      subject { klass[''] }

      it { is_expected.to be_nil }
    end

    [-12_345, -1_234, -123, -1, 0, 1, 12, 123, 1_234.0, 12_345].each do |invalid_number|
      context "with #{invalid_number}" do
        it 'raises ConstraintError' do
          expect { klass[invalid_number] }.to raise_error(Dry::Types::ConstraintError)
        end
      end
    end

    context 'with 4 digits' do
      subject { klass[1_234] }

      it { is_expected.to eq('1234') }
    end

    context 'when created with valid string' do
      include_examples 'equals input', '1234'
    end

    context 'when created with a too many digits' do
      include_examples 'raises ConstraintError', '12345'
    end

    context 'when created with too few digits' do
      include_examples 'raises ConstraintError', '123'
    end

    context 'when created with a negative number' do
      include_examples 'raises ConstraintError', '-1234'
    end

    context 'when created with characters' do
      include_examples 'raises ConstraintError', 'abcd'
    end
  end
end
