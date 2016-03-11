require 'spec_helper'
require 'fortnox/api/validators/base'
require 'fortnox/api/validators/validator_examples'

describe Fortnox::API::Validator::Base do

  using_test_classes do
    class Validator < Fortnox::API::Validator::Base
    end

    class Model
    end
  end

  subject{ Validator.new }

  it_behaves_like 'validators' do
    before do
      Validator.using_validations do
          # Initialize validator
      end
    end
  end

  context 'when no validator given' do
    let( :model ){ Model.new }

    specify '#validate raises an error' do
      expect{ subject.validate( model ) }.to raise_error(ArgumentError)
    end

    specify '#instance raises an error' do
      expect{ subject.instance }.to raise_error(ArgumentError)
    end

    specify '#violations raises an error' do
      expect{ subject.violations }.to raise_error(ArgumentError)
    end
  end
end
