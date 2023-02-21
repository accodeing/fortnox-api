# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types::Email do
  let(:klass) { described_class }

  context 'when created with nil' do
    subject { described_class[nil] }

    it { is_expected.to be_nil }
  end

  context 'when created with empty string' do
    subject { described_class[''] }

    it { is_expected.to eq('') }
  end

  context 'when created with valid email' do
    valid_emails = [
      'valid@example.com',
      'kanal_75_ab-faktura@mail.unit4agresso.readsoftonline.com',
      'sköldpadda@example.com'
    ]

    valid_emails.each do |email|
      it { expect(described_class[email]).to eq email }
    end
  end

  context 'when created with invalid email' do
    include_examples 'raises ConstraintError', 'te$£@st@example.com'
  end

  context 'when created with more than 1024 characters' do
    legal_characters = 'abcdefghijklmnopqrstuvwxyz0123456789.-_+'.chars
    too_long_email = "#{(legal_characters * 35).shuffle.join}@example.com"
    include_examples 'raises ConstraintError', too_long_email
  end
end
