# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/terms_of_payments'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::TermsOfPayments, order: :defined, integration: true do
  include Helpers::Configuration

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  required_hash = { code: '15DAYS' }

  include_examples '.save', :description, additional_attrs: required_hash

  include_examples '.all', 9

  include_examples '.find', '15DAYS', find_by_hash: false do
    let(:find_by_hash_failure) { { code: '15days' } }
    let(:single_param_find_by_hash) { { find_hash: { code: '30days' }, matches: 1 } }
  end
end
