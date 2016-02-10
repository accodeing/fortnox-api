require 'spec_helper'
require 'fortnox/api/validators/base'
require 'fortnox/api/validators/validator_examples'

describe Fortnox::API::Validator::Base do
  subject{ Class.new{ include Fortnox::API::Validator::Base }.new }

  it{ is_expected.to respond_to( :validate ) }
  it{ is_expected.to respond_to( :violations ) }
  it{ is_expected.to respond_to( :instance ) }

  context 'when validator present' do
    before do
      subject.using_validations do
        # Initialize validator
      end
    end

    specify '#violations returns an empty Set when no violations present' do
      expect(subject.violations).to eq(Set.new)
    end

    specify '#validate returns true when model valid' do
      dummy_model = Class.new{}.new
      expect(subject.validate( dummy_model )).to be true
    end

    specify '#instance returns self' do
      expect(subject.instance).to be subject
    end
  end

  context 'when no validator given' do
    let( :dummy_model ){ Class.new{}.new }

    specify '#validate raises an error' do
      expect{ subject.validate( dummy_model ) }.to raise_error(ArgumentError)
    end

    specify '#instance raises an error' do
      expect{ subject.instance }.to raise_error(ArgumentError)
    end

    specify '#violations raises an error' do
      expect{ subject.violations }.to raise_error(ArgumentError)
    end
  end
end
