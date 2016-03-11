require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/validators/attributes/currency'
require 'fortnox/api/validators/attributes/examples_for_validate'

describe Fortnox::API::Validator::Attribute::Currency do

  include_examples '.validate', :currency do
    let( :invalid_attribute ){ '-_-' }
    let( :valid_attribute ){ 'SEK' }
  end
end
