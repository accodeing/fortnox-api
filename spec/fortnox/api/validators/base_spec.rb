require 'spec_helper'
require 'fortnox/api/validators/base'
require 'fortnox/api/validators/validator_examples'

describe Fortnox::API::Validator::Base do
  subject{ Class.new{ include Fortnox::API::Validator::Base }.new }

  it_behaves_like 'validators' do
    before do
      subject.using_validations do
        # Initialize validator
      end
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
