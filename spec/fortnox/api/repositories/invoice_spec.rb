require 'spec_helper'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'

describe Fortnox::API::Repository::Invoice, order: :defined, integration: true do
  include_context 'environment'

  include_examples '.save', :comments, { customer_number: 1 }

  include_examples '.all'

  include_examples '.find'
end
