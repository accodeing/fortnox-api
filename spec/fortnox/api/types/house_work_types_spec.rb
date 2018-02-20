# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/types'
require 'fortnox/api/repositories/order'
require 'fortnox/api/models/order'
require 'fortnox/api/types/order_row'

describe 'HouseWorkTypes', integration: true do
  include Helpers::Configuration

  before { set_api_test_configuration }

  let(:repository) { Fortnox::API::Repository::Order.new }
  let(:valid_model) do
    Fortnox::API::Model::Order.new(customer_number: '1', order_rows: [order_row])
  end
  let(:order_row) do
    Fortnox::API::Types::OrderRow.new(ordered_quantity: 1,
                                      article_number: '0000',
                                      house_work_type: house_work_type) end

  shared_examples_for 'house work type' do |type, legacy: false|
    subject do
      lambda do
        VCR.use_cassette("orders/house_work_type_#{type.downcase}") do
          repository.save(valid_model)
        end
      end
    end

    let(:error_message) { 'Skattereduktion för en av de valda husarbetestyperna har upphört.' }
    let(:house_work_type) { Fortnox::API::Types::HouseWorkTypes[type] }

    context "when creating an OrderRow with house_work_type set to #{type}" do
      if legacy
        it 'raises an error' do
          is_expected.to raise_error(Fortnox::API::RemoteServerError, error_message)
        end
      else
        it { is_expected.not_to raise_error }
      end
    end
  end

  it_behaves_like 'house work type', 'CONSTRUCTION'
  it_behaves_like 'house work type', 'ELECTRICITY'
  it_behaves_like 'house work type', 'GLASSMETALWORK'
  it_behaves_like 'house work type', 'GROUNDDRAINAGEWORK'
  it_behaves_like 'house work type', 'MASONRY'
  it_behaves_like 'house work type', 'PAINTINGWALLPAPERING'
  it_behaves_like 'house work type', 'HVAC'
  it_behaves_like 'house work type', 'CLEANING'
  it_behaves_like 'house work type', 'TEXTILECLOTHING'
  it_behaves_like 'house work type', 'CLEANING'
  it_behaves_like 'house work type', 'SNOWPLOWING'
  it_behaves_like 'house work type', 'GARDENING'
  it_behaves_like 'house work type', 'BABYSITTING'
  it_behaves_like 'house work type', 'OTHERCARE'
  it_behaves_like 'house work type', 'OTHERCOSTS'

  it_behaves_like 'house work type', 'COOKING', legacy: true
  it_behaves_like 'house work type', 'TUTORING', legacy: true
end
# rubocop:enable RSpec/DescribeClass
