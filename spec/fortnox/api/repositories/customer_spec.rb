require 'spec_helper'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Customer, order: :defined, integration: true do
  include_context 'environment'

  include_examples '.save', :name

  include_examples '.all'

  include_examples '.find'

  include_examples '.search', :name, 'Test'
end
