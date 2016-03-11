require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/validators/attributes/currency'
require 'fortnox/api/validators/attributes/examples_for_validate'

describe Fortnox::API::Validator::Attribute::Currency do

  using_test_classes do
    class Model < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::Currency
    end

    class Validator < Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::Currency
    end
  end

  include_examples '.validate', :currency do
    let( :invalid_attribute ){ '-_-' }
    let( :valid_attribute ){ 'SEK' }
    let( :validator_class ){ Validator }
    let( :model_class ){ Model }
  end
end
