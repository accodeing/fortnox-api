# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types::Country do
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

    it 'translates English country names to country code' do
      expect(described_class['Norway']).to eq 'NO'
    end

    it 'translates Swedish country names to country code' do
      expect(described_class['Norge']).to eq 'NO'
    end

    describe 'special cases' do
      valid_sweden_inputs = [
        'SE', 'se', 'Sweden', 'sweden', 'Sverige', 'sverige',
        :SE, :se, :Sweden, :sweden, :Sverige, :sverige
      ].freeze

      valid_sweden_inputs.each do |sweden_input|
        it "converts \"#{sweden_input}\" to \"SE\"" do
          expect(described_class[sweden_input]).to eq 'SE'
        end
      end

      it 'accepts country code for El Salvador' do
        expect(described_class['SV']).to eq 'SV'
      end

      it 'translated Switzerland to' do
        expect(described_class['Switzerland']).to eq 'CH'
      end
    end
  end

  context 'with invalid input' do
    invalid_inputs = [
      'SEA', 'S', 'nonsense', :s
    ].freeze

    invalid_inputs.each do |invalid_input|
      it "#{invalid_input} raises Dry::Types::ConstraintError" do
        expect do
          described_class[invalid_input]
        end.to raise_error(Dry::Types::ConstraintError)
      end
    end
  end
end
