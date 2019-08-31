# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types::CountryCode do
  context 'with nil' do
    subject { described_class[nil] }

    it { is_expected.to be_nil }
  end

  context 'with empty string' do
    subject { described_class[''] }

    it { is_expected.to eq('') }
  end

  context 'with valid input' do
    it 'accepts country codes' do
      expect(described_class['NO']).to eq 'NO'
    end
  end

  context 'with invalid input' do
    describe 'valid country name' do
      it do
        expect do
          described_class['Norway']
        end.to raise_error(Dry::Types::ConstraintError)
      end
    end

    describe 'invalid country code' do
      it do
        expect do
          described_class['XX']
        end.to raise_error(Dry::Types::ConstraintError)
      end
    end
  end
end
