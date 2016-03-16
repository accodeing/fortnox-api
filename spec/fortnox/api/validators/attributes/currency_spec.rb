require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/validators/attributes/currency'
require 'fortnox/api/validators/attributes/examples_for_validate'

describe Fortnox::API::Validator::Attribute::Currency do
  include_examples '.validate', :currency, '-_-', 'SEK'
end
