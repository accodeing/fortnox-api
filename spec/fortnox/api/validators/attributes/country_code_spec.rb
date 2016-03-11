require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'
require 'fortnox/api/validators/attributes/examples_for_validate'

describe Fortnox::API::Validator::Attribute::CountryCode do

  using_test_classes do
    class Model < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::CountryCode
    end

    class Validator < Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::CountryCode
    end
  end

  include_examples '.validate', :country_code do
    let( :invalid_attribute ){ 'aaa' }
    let( :valid_attribute ){ 'SE' }
    let( :validator_class ){ Validator }
    let( :model_class ){ Model }
  end
end
