require 'spec_helper'
require 'fortnox/api/validators/constant'
require 'fortnox/api/validators/validator_examples'

describe Fortnox::API::Validator::Constant do

  subject{ Fortnox::API::Validator::Constant.new }

  it_behaves_like 'validators' do
    let( :valid_model ){ Class.new{}.new }
  end
end
