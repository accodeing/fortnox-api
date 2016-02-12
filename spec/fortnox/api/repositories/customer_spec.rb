require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Repository::Customer do
  include_context 'repository context'

  it_behaves_like 'repositories', Fortnox::API::Model::Customer
end
