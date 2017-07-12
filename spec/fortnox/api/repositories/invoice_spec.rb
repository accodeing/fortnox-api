require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/search'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_nested_model'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/only'

describe Fortnox::API::Repository::Invoice, order: :defined, integration: true do
  subject(:repository){ described_class.new }

  required_hash = { customer_number: '1' }

  include_examples '.save', :comments, required_hash

  nested_model_hash = { price: 10, article_number: '0000' }
  include_examples '.save with nested model',
                   required_hash,
                   :invoice_rows,
                   nested_model_hash,
                   [ Fortnox::API::Types::InvoiceRow.new( nested_model_hash ) ]

  include_examples '.save with specially named attribute',
                   required_hash,
                   :ocr,
                   '426523791'

  # It is not possible to delete Invoces. Therefore, expected nr of Orders
  # when running .all will continue to increase (until 100, which is max by default).
  include_examples '.all', 60

  include_examples '.find', 1 do
    let( :find_by_hash_failure ) { { yourreference: 'Not found' } }

    let( :single_param_find_by_hash ) do
      { find_hash: { yourreference: 'Gandalf the Grey' }, matches: 2 }
    end
    let( :multi_param_find_by_hash ) do
      { find_hash: { yourreference: 'Gandalf the Grey', ourreference: 'Radagast the Brown' },
        matches: 1 }
    end
  end

  include_examples '.search', :customername, 'Test', 3

  include_examples '.only', :fullypaid, 1
end
