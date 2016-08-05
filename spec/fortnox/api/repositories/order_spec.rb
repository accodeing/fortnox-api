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

  context 'when saving an Order with OrderRows' do
    shared_examples 'OrderRow attributes' do |order_row, attribute_map|
      describe 'response' do
        let( :order_row_response ) do
          entity_wrapper = described_class.new.options.json_entity_wrapper
          response[entity_wrapper]['OrderRows'][order_row]
        end

        attribute_map.each do |attribute, value|
          it "includes #{attribute.inspect}" do
            expect( order_row_response[attribute] ).to eq( value )
          end
        end
      end
    end
    let(:response) do
      model = Fortnox::API::Model::Order.new(
        {
          customer_number: '1',
          comments: 'A great comment about something',
          order_rows: [
            { price: 100.0,
              vat: 6,
              article_number: '1',
              ordered_quantity: 1 },
            { price: 101.5,
              vat: 0,
              article_number: '1',
              ordered_quantity: 2.5 }]
        }
      )

      VCR.use_cassette( 'orders/save_new_with_order_rows' ) do
        described_class.new.save( model )
      end
    end

    include_examples 'OrderRow attributes',
                     0,
                     {
                       'Price' => 100.0,
                       'VAT' => 6,
                       'ArticleNumber' => '1',
                       'OrderedQuantity' => '1.00'
                     }

    include_examples 'OrderRow attributes',
                     1,
                     {
                       'Price' => 101.5,
                       'VAT' => 0,
                       'ArticleNumber' => '1',
                       'OrderedQuantity' => '2.50'
                     }
  end
end
