require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'

describe Fortnox::API::Validator::Attribute::CountryCode do

  before(:all) do
    class TestModel < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::CountryCode
    end

    class TestValidator
      extend Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::CountryCode
    end
  end

  after(:all) do
    Object.send(:remove_const, :TestModel)
    Object.send(:remove_const, :TestValidator)
  end

  describe '.validate' do
    context 'does not allow bogus country_code value' do
      let( :instance ){ TestModel.new( country_code: 'aaa' ) }
      subject{ TestValidator.validate( instance ) }
      it{ is_expected.to eql( false ) }
    end
  end

end
