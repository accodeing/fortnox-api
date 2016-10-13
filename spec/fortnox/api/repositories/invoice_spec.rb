require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/contexts/environment'
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

  include_context 'environment'

  required_hash = { customer_number: '1' }

  include_examples '.save', :comments, required_hash

  nested_model_hash = { price: 10, article_number: '0000' }
  include_examples '.save with nested model',
                   required_hash,
                   :invoice_rows,
                   nested_model_hash,
                   [ Fortnox::API::Model::InvoiceRow.new( nested_model_hash ) ]

  include_examples '.save with specially named attribute',
                   required_hash,
                   :ocr,
                   '426523791'

  # It is not possible to delete Invoces. Therefore, expected nr of Orders
  # when running .all will continue to increase.
  include_examples '.all', 32

  include_examples '.find', 1

  include_examples '.search', :customername, 'Test'

  include_examples '.only', :fullypaid, 1, missing_filter: :unpaid
end
