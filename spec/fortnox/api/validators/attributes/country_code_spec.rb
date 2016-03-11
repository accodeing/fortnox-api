require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'
require 'fortnox/api/validators/attributes/examples_for_validate'
require 'fortnox/api/validators/attributes/test_classes_context'

describe Fortnox::API::Validator::Attribute::CountryCode do

  include_context 'Model and Validator classes',
                  Fortnox::API::Model::Attribute::CountryCode,
                  Fortnox::API::Validator::Attribute::CountryCode

  include_examples '.validate', :country_code do
    let( :invalid_attribute ){ 'aaa' }
    let( :valid_attribute ){ 'SE' }
    let( :validator_class ){ Validator }
    let( :model_class ){ Model }
  end
end
