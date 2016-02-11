require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Repository::Customer do

  include_context 'repository context' do
    let( :model_class ){ Fortnox::API::Model::Customer }
  end

  include_examples '#save', 'Customer'
end
