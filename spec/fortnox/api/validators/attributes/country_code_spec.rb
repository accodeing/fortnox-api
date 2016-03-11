require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'

describe Fortnox::API::Validator::Attribute::CountryCode do

  using_test_classes do
    class Model < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::CountryCode
    end

    class Validator < Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::CountryCode

      using_validations do

      end
    end
  end

  describe '.validate' do
    context 'does not allow bogus country_code value' do
      let( :instance ){ Model.new( country_code: 'aaa' ) }

      subject{ Validator.new }

      specify{ expect(subject.validate( instance )).to eql( false ) }
    end
  end

end
