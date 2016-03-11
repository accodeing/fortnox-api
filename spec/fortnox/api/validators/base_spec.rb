require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/validators/base'
require 'fortnox/api/validators/validator_examples'

describe Fortnox::API::Validator::Base do

  using_test_classes do
    class Model < Fortnox::API::Model::Base
      attribute :test_attribute, String
    end

    class Validator < Fortnox::API::Validator::Base
      using_validations do
        validates_presence_of :test_attribute
      end
    end
  end

  subject{ Validator.new }

  it_behaves_like 'validators'

  it 'does not keep violations' do
    invalid_model = Model.new
    valid_model = Model.new(test_attribute: 'test')

    expect(subject.validate( invalid_model )).to be false
    expect(subject.validate( valid_model )).to be true

    another_validator = described_class.new

    expect( another_validator.validate( invalid_model ) ).to be false
    expect( another_validator.validate( valid_model ) ).to be true
  end

  context 'when no validator given' do
    let( :model ){ Model.new }

    subject{ described_class.new }

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
