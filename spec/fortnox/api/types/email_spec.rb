require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/types'

describe Fortnox::API::Types do
  let( :klass ){ Fortnox::API::Types::Email }

  context 'Email created with nil' do
    subject{ klass[ nil ] }
    it{ is_expected.to be_nil }
  end

  context 'Email created with empty string' do
    subject{ klass[ '' ] }
    it{ is_expected.to eq('') }
  end

  context 'Email created with valid email' do
    subject{ klass[ input ] }
    let( :input ){ 'test@example.com' }
    it{ is_expected.to eq input }
  end

  context 'Email created with more than 1024 characters' do
    legal_characters = 'abcdefghijklmnopqrstuvwxyz-_+'.split('')
    too_long_email = (legal_characters * 35).shuffle.join + '@example.com'
    include_examples 'raises ConstraintError', too_long_email
  end
end
