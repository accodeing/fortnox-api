require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'

describe Fortnox::API::Validator::Attribute::CountryCode do

  using_test_classes do
    class TestModel < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::CountryCode
    end

    class TestValidator
      extend Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::CountryCode

      using_validations do

      end
    end
  end

  describe '.validate' do
    context 'does not allow bogus country_code value' do
      let( :instance ){ TestModel.new( country_code: 'aaa' ) }
      subject{ TestValidator.validate( instance ) }
      it{ is_expected.to eql( false ) }
    end
  end

end
