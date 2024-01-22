# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/terms_of_payment'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::TermsOfPayment, order: :defined, integration: true do
  include Helpers::Configuration

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  # When recording new VCR cassettes, code must be changed to a new unique one
  required_hash = { code: '20DAYS' }

  include_examples '.save', :description, additional_attrs: required_hash

  # When recording new VCR cassettes, expected matches needs to be increased
  include_examples '.all', 14

  include_examples '.find', '15DAYS', find_by_hash: false do
    let(:find_by_hash_failure) { { code: '15days' } }
    let(:single_param_find_by_hash) { { find_hash: { code: '30days' }, matches: 1 } }
  end
end
