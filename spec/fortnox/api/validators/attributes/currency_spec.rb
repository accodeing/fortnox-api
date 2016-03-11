require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/validators/attributes/currency'
require 'fortnox/api/validators/attributes/examples_for_validate'
require 'fortnox/api/validators/attributes/test_classes_context'

describe Fortnox::API::Validator::Attribute::Currency do

  include_context 'Model and Validator classes',
                  Fortnox::API::Model::Attribute::Currency,
                  Fortnox::API::Validator::Attribute::Currency

  include_examples '.validate', :currency do
    let( :invalid_attribute ){ '-_-' }
    let( :valid_attribute ){ 'SEK' }
    let( :validator_class ){ Validator }
    let( :model_class ){ Model }
  end
end
