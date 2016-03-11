require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/validators/attributes/currency'

describe Fortnox::API::Validator::Attribute::Currency do

  using_test_classes do
    class Model < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::Currency
    end

    class Validator < Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::Currency
    end
  end

  describe '.validate' do
    context 'model with invalid currency attribute' do
      let( :instance ){ Model.new( currency: '-_-' ) }

      subject{ Validator.new }

      specify{ expect(subject.validate( instance )).to eql( false ) }
    end
  end

end
