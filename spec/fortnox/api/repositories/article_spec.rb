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

  before { set_api_test_configuration }

  subject(:repository){ described_class.new }

  include_examples '.save',
                   :description,
                   additional_attrs: { sales_account: 1250 }

  include_examples '.save with specially named attribute',
                   { description: 'Test article' },
                   :ean,
                   '5901234123457'

  include_examples '.all', 12

  include_examples '.find', '1' do
    let( :find_by_hash_failure ){ { description: 'Not Found' } }
    let( :single_param_find_by_hash ){ { find_hash: { articlenumber: 1 }, matches: 3 } }

    let( :multi_param_find_by_hash ) do
      { find_hash: { articlenumber: 1, description: 'Cykelpump' }, matches: 1 }
    end
  end

  include_examples '.search', :description, 'Testartikel', 2
end
