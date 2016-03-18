require 'spec_helper'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/only'

describe Fortnox::API::Repository::Invoice, order: :defined, integration: true do
  include_context 'environment'

  # It is not possible to delete Invoces. Therefore, expected nr of Orders
  # when running .all will continue to increase.
  include_examples '.all', 12

  include_examples '.find'

  include_examples '.search', :customername, 'Test'
  
  include_examples '.save', :comments, { customer_number: 1 }

  include_examples '.only', :fullypaid, :unpaid
end
