require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'
require 'fortnox/api/validators/attributes/examples_for_validate'

describe Fortnox::API::Validator::Attribute::CountryCode do
  include_examples '.validate', :country_code, 'aaa', 'SE'
end
