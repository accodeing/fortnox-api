require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'
require 'fortnox/api/validators/attributes/examples_for_validate'

describe Fortnox::API::Validator::Attribute::CountryCode do

  include_examples '.validate',
                   :country_code,
                   Fortnox::API::Model::Attribute::CountryCode,
                   Fortnox::API::Validator::Attribute::CountryCode do
    let( :invalid_attribute ){ 'aaa' }
    let( :valid_attribute ){ 'SE' }
    let( :validator_class ){ Validator }
    let( :model_class ){ Model }
  end
end
