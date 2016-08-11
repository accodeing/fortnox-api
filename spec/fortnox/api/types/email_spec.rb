require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types do
  describe 'Email' do
    let( :described_class ){ Fortnox::API::Types::Email }
    let( :legal_characters ){ 'abcdefghijklmnopqrstuvwxyz-_+'.split('') }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with empty string' do
      let( :input ){ '' }
      subject{ -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end

    context 'created with valid email' do
      let( :input ){ 'test@example.com' }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with more than 1024 characters' do
      let( :input ){ (legal_characters*35).shuffle.join + '@example.com' }
      subject{ -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end
  end
end
