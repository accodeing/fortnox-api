require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/order'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/only'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_nested_model'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Order, order: :defined, integration: true do
  subject(:repository){ described_class.new }

  include_context 'environment'

  required_hash = { customer_number: '1' }
  include_examples '.save', :comments, required_hash
  include_examples '.save with nested model',
                   required_hash,
                   :order_rows,
                   [ Fortnox::API::Model::OrderRow.new( price: 10,
                                                        price_excluding_vat: 7,
                                                        order_quantity: 1 ) ]

  # It is not possible to delete Orders. Therefore, expected nr of Orders
  # when running .all will continue to increase.
  include_examples '.all', 8

  include_examples '.find', 1

  include_examples '.search', :customername, 'A customer'

  include_examples '.only', :cancelled, 2

  describe 'OrderRow' do
    let(:model) do
      Fortnox::API::Model::Order.new(
        {
          customer_number: '1',
          comments: 'A great comment about something',
          order_rows: [Fortnox::API::Model::OrderRow.new( price: 100.0, order_quantity: 1 ),
                      Fortnox::API::Model::OrderRow.new( price: 101.5, order_quantity: 2.5 )]
        }
)
    end

    it 'saves an Order with OrderRows' do
      VCR.use_cassette('orders/save_new_with_order_rows') do
        repository.save(model)
      end
    end
  end
end
