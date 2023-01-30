# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/unit'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'

describe Fortnox::API::Repository::Unit, integration: true, order: :defined do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  # VCR: code needs to be changed to a unique value
  include_examples '.save',
                   :description,
                   additional_attrs: { code: 'blarg9' }

  # VCR: code needs to be changed to a unique value
  include_examples '.save with specially named attribute',
                   { description: 'Happy clouds' },
                   :code,
                   'woooh7'

  include_examples '.all'

  # VCR: code must be updated
  include_examples '.find', 'blarg7', find_by_hash: false do
    let(:find_by_hash_failure) { { code: 'notfound' } }
    let(:single_param_find_by_hash) { { find_hash: { code: 'blarg7' }, matches: 1 } }
  end
end
