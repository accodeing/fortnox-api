require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types do
  describe 'Email' do
    let( :described_class ){ Fortnox::API::Types::Email }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with empty string' do
      include_examples 'raises ConstraintError', ''
    end

    context 'created with valid email' do
      let( :input ){ 'test@example.com' }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with more than 1024 characters' do
      legal_characters = 'abcdefghijklmnopqrstuvwxyz-_+'.split('')
      too_long_email = (legal_characters * 35).shuffle.join + '@example.com'
      include_examples 'raises ConstraintError', too_long_email
    end
  end
end
