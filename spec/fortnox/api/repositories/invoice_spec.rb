require 'spec_helper'
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

  include_examples '.save with nested model',
                   required_hash,
                   :invoice_rows,
                   [ { price: 10, price_excluding_vat: 7 } ]

  include_examples '.save with specially named attribute',
                   required_hash.merge(ocr: '426523791'),
                   :ocr,
                   'OCR'

  # It is not possible to delete Invoces. Therefore, expected nr of Orders
  # when running .all will continue to increase.
  include_examples '.all', 12

  include_examples '.find'

  include_examples '.search', :customername, 'Test'

  include_examples '.only', :fullypaid, 1, missing_filter: :unpaid
end
