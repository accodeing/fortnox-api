require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Repository::Customer do
  include_context 'repository context' do
    let( :model ){ Fortnox::API::Model::Customer.new( unsaved: false ) }
    let( :repository ){ Fortnox::API::Repository::Customer.new }
  end

  include_examples '#save', 'Customer'
end
