require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Customer, order: :defined, integration: true do
  subject(:repository){ described_class.new }

  include_context 'environment'

  include_examples '.save', :name

  include_examples '.save with specially named attribute',
                   { name: 'Test customer', email_invoice_cc: 'test@example.com' },
                   :email_invoice_cc,
                   'EmailInvoiceCC'

  # It is not yet possible to delete Customers. Therefore, expected nr of
  # Customers when running .all will continue to increase.
  include_examples '.all', 39

  include_examples '.find'

  include_examples '.search', :name, 'Test'
end
