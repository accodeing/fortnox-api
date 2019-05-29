# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

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
    it 'accepts english country names' do
      expect(described_class['Norway']).to eq 'Norway'
    end

    it 'translates swedish country names to english' do
      expect(described_class['Norge']).to eq 'Norway'
    end

    it 'translates country codes to english country name' do
      expect(described_class['NO']).to eq 'Norway'
    end

    describe 'special cases' do
      valid_sweden_inputs = [
        'SE', 'se', 'Sweden', 'sweden', 'Sverige', 'sverige',
        :SE, :se, :Sweden, :sweden, :Sverige, :sverige
      ].freeze

      valid_sweden_inputs.each do |sweden_input|
        it "converts \"#{sweden_input}\" to \"Sverige\"" do
          expect(described_class[sweden_input]).to eq 'Sverige'
        end
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
