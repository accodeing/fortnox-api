require 'spec_helper'
require 'fortnox/api/validators/constant'
require 'fortnox/api/validators/validator_examples'

describe Fortnox::API::Validator::Constant do
  subject{ Class.new{ include Fortnox::API::Validator::Constant }.new }

  it_behaves_like 'validators'
end
