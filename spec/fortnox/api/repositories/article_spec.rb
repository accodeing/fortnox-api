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

describe Fortnox::API::Repository::Article, order: :defined, integration: true do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  include_examples '.save',
                   :description,
                   additional_attrs: { sales_account: 1250 }

  include_examples '.save with specially named attribute',
                   { description: 'Test article' },
                   :ean,
                   '5901234123457'

  # When recording new VCR cassettes, expected matches must be increased
  include_examples '.all', 1

  # When recording new VCR cassettes, expected matches must be increased
  include_examples '.find', '1' do
    let(:find_by_hash_failure) { { description: 'Not Found' } }
    let(:single_param_find_by_hash) { { find_hash: { articlenumber: 101 }, matches: 1 } }

    let(:multi_param_find_by_hash) do
      { find_hash: { articlenumber: 101, description: 'Hammer' }, matches: 1 }
    end
  end

  include_examples '.search', :description, 'Test article', 3
end
