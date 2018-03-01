# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/types'
require 'fortnox/api/repositories/order'
require 'fortnox/api/models/order'
require 'fortnox/api/types/order_row'

# rubocop:disable RSpec/DescribeClass
describe 'HouseworkTypes', integration: true do
  include Helpers::Configuration

  before { set_api_test_configuration }

  let(:repository) { Fortnox::API::Repository::Order.new }
  let(:valid_model) do
    Fortnox::API::Model::Order.new(customer_number: '1', order_rows: [order_row])
  end
  let(:order_row) do
    Fortnox::API::Types::OrderRow.new(ordered_quantity: 1,
                                      article_number: '0000',
                                      housework_type: housework_type)
  end

  shared_examples_for 'housework type' do |type, legacy: false|
    subject do
      lambda do
        VCR.use_cassette("orders/housework_type_#{type.downcase}") do
          repository.save(valid_model)
        end
      end
    end

    let(:error_message) { 'Skattereduktion för den valda typen av husarbete har upphört.' }
    let(:housework_type) { Fortnox::API::Types::HouseworkTypes[type] }

    context "when creating an OrderRow with housework_type set to #{type}" do
      if legacy
        it 'raises an error' do
          is_expected.to raise_error(Fortnox::API::RemoteServerError, error_message)
        end
      else
        it { is_expected.not_to raise_error }
      end
    end
  end

  it_behaves_like 'housework type', 'CONSTRUCTION'
  it_behaves_like 'housework type', 'ELECTRICITY'
  it_behaves_like 'housework type', 'GLASSMETALWORK'
  it_behaves_like 'housework type', 'GROUNDDRAINAGEWORK'
  it_behaves_like 'housework type', 'MASONRY'
  it_behaves_like 'housework type', 'PAINTINGWALLPAPERING'
  it_behaves_like 'housework type', 'HVAC'
  it_behaves_like 'housework type', 'CLEANING'
  it_behaves_like 'housework type', 'TEXTILECLOTHING'
  it_behaves_like 'housework type', 'CLEANING'
  it_behaves_like 'housework type', 'SNOWPLOWING'
  it_behaves_like 'housework type', 'GARDENING'
  it_behaves_like 'housework type', 'BABYSITTING'
  it_behaves_like 'housework type', 'OTHERCARE'
  it_behaves_like 'housework type', 'OTHERCOSTS'

  it_behaves_like 'housework type', 'COOKING', legacy: true
  it_behaves_like 'housework type', 'TUTORING', legacy: true
end
# rubocop:enable RSpec/DescribeClass
