# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Article, integration: true, order: :defined do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  # VCR: Requires a Financial Year in Fortnox, otherwise the sales account is not be available.
  # VCR: Update requires that default accounts exists in the chart of accounts
  include_examples '.save',
                   :description,
                   additional_attrs: { sales_account: 1250 }

  include_examples '.save with specially named attribute',
                   { description: 'Test article' },
                   :ean,
                   '5901234123457'

  # VCR: expected matches must be increased
  include_examples '.all', 6

  # VCR: Expected matches must be increased
  # VCR: Create the searched Articles manually in Fortnox
  include_examples '.find', '1' do
    let(:find_by_hash_failure) { { description: 'Not Found' } }
    let(:single_param_find_by_hash) { { find_hash: { articlenumber: 101 }, matches: 1 } }

    let(:multi_param_find_by_hash) do
      { find_hash: { articlenumber: 101, description: 'Hammer' }, matches: 1 }
    end
  end

  # VCR: Expected mathes must be updated
  include_examples '.search', :description, 'Test article', 3

  describe 'limits' do
    let(:article) do
      VCR.use_cassette("#{vcr_dir}/#{cassette}") do
        repository.save(described_class::MODEL.new(**attributes))
      end
    end

    describe 'quantity_in_stock' do
      let(:cassette) { 'limits/quantity_in_stock_min_value' }
      let(:attributes) do
        {
          description: 'Test article',
          quantity_in_stock: quantity_in_stock
        }
      end
      let(:quantity_in_stock) { -99_999_999_999_999.9 }

      it 'has a lower limit' do
        expect(article.quantity_in_stock).to eq(-100_000_000_000_000.0)
      end

      context 'when positive' do
        let(:cassette) { 'limits/quantity_in_stock_rounding_positive_value' }
        let(:quantity_in_stock) { 1.123 }

        it 'rounds to two decimals' do
          expect(article.quantity_in_stock).to eq(1.12)
        end
      end
    end
  end
end
