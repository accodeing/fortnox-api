require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/validators/attributes/currency'

describe Fortnox::API::Validator::Attribute::Currency do

  before(:all) do
    class TestModel < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::Currency
    end

    class TestValidator
      extend Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::Currency
    end
  end

  after(:all) do
    Object.send(:remove_const, :TestModel)
    Object.send(:remove_const, :TestValidator)
  end

  describe '.validate' do
    context 'model with invalid currency attribute' do
      let( :instance ){ TestModel.new( currency: '-_-' ) }

      it 'is invalid' do
        expect( TestValidator.validate( instance )).to eql( false )
      end
    end
  end

end
