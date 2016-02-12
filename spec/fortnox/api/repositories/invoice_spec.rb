require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/models/invoice'

describe Fortnox::API::Repository::Invoice do
  include_context 'repository context'

  it_behaves_like 'repositories', Fortnox::API::Model::Invoice
end
