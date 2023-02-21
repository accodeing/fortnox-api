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

describe Fortnox::API::Repository::TermsOfPayment, integration: true, order: :defined do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  # VCR: code must be changed to a new unique one
  required_hash = { code: '21DAYS' }

  include_examples '.save', :description, additional_attrs: required_hash

  # VCR: expected matches needs to be increased
  include_examples '.all', 10

  # VCR: The terms of payment searched here needs to be created manually in Fortnox
  include_examples '.find', '19DAYS', find_by_hash: false do
    let(:find_by_hash_failure) { { code: '19days' } }
    let(:single_param_find_by_hash) { { find_hash: { code: '30days' }, matches: 1 } }
  end
end
