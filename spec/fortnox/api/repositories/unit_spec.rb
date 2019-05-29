# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/unit'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'

describe Fortnox::API::Repository::Unit, order: :defined, integration: true do
  include Helpers::Configuration

  before { set_api_test_configuration }

  subject(:repository) { described_class.new }

  # When recording new VCR cassettes, code needs to be changed to a unique value
  include_examples '.save',
                   :description,
                   additional_attrs: { code: 'blarg3' }

  # When recording new VCR cassettes, code needs to be changed to a unique value
  include_examples '.save with specially named attribute',
                   { description: 'Happy clouds' },
                   :code,
                   'woooh3'

  # When recording new VCR cassettes, expected number must be updated
  include_examples '.all', 10

  include_examples '.find', 'blarg', find_by_hash: false do
    let(:find_by_hash_failure) { { code: 'notfound' } }
    let(:single_param_find_by_hash) { { find_hash: { code: 'blarg' }, matches: 1 } }
  end
end
