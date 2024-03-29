# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/order'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/only'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_nested_model'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Order, integration: true, order: :defined do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  required_hash = { customer_number: '1' }

  include_examples '.save', :comments, additional_attrs: required_hash

  nested_model_hash = { price: -9_999_999_999, article_number: '101', ordered_quantity: 1 }
  include_examples '.save with nested model',
                   required_hash,
                   :order_rows,
                   nested_model_hash,
                   [Fortnox::API::Types::OrderRow.new(nested_model_hash)]

  # VCR: Update expected result
  include_examples '.all', 7

  # VCR: Searched Orders needs to be created manually in Fortnox
  include_examples '.find', 1 do
    let(:find_by_hash_failure) { { ourreference: 'Not found' } }

    let(:single_param_find_by_hash) do
      { find_hash: { ourreference: 'Belladonna Took' }, matches: 2 }
    end
    let(:multi_param_find_by_hash) do
      { find_hash: { ourreference: 'Belladonna Took', yourreference: 'Bodo Proudfoot' },
        matches: 1 }
    end
  end

  # VCR: Searched Order needs to be created manually
  include_examples '.search', :customername, 'A customer', 1

  include_examples '.only', :cancelled, 2
end
