require 'spec_helper'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/order'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/only'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Order, order: :defined, integration: true do
  include_context 'environment'

  include_examples '.save', :comments, { customer_number: 1 }

  # It is not possible to delete Orders. Therefore, expected nr of Orders
  # when running .all will continue to increase.
  include_examples '.all', 8

  include_examples '.find'

  include_examples '.search', :customername, 'A customer'

  include_examples '.only', :cancelled, 2

  describe 'OrderRow', focus: true do
    let(:model) do
      Fortnox::API::Model::Order.new(
        {
          customer_number: '1',
          comments: 'A great comment about something',
          order_rows: [{price: 100.0}, {price: 101.5}]
        })
    end

    it 'should save an Order with OrderRows' do
      VCR.use_cassette('orders/save_new_with_order_rows') do
        described_class.new.save(model)
      end
    end
  end
end
