require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Customer, order: :defined, integration: true do
  include Helpers::Configuration

  before { set_api_test_configuration }

  subject(:repository){ described_class.new }

  include_examples '.save', :name

  include_examples '.save with specially named attribute',
                   { name: 'Test customer' },
                   :email_invoice_cc,
                   'test@example.com'

  # It is not yet possible to delete Customers. Therefore, expected nr of
  # Customers when running .all will continue to increase
  # (until 100, which is max by default).
  include_examples '.all', 100

  include_examples '.find', '1' do
    let( :find_by_hash_failure ){ { city: 'Not Found' } }
    let( :single_param_find_by_hash ){ { find_hash: { city: 'New York' }, matches: 2 } }

    let( :multi_param_find_by_hash ) do
      { find_hash: { city: 'New York', zipcode: '10001' }, matches: 1 }
    end
  end

  include_examples '.search', :name, 'Test', 23
end
