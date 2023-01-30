# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/project'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'

describe Fortnox::API::Repository::Project, integration: true, order: :defined do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  include_examples '.save',
                   :comments,
                   additional_attrs: { description: 'Some important project' }

  include_examples '.all'

  include_examples '.find', '1' do
    let(:find_by_hash_failure) { { offset: 10_000 } }
    let(:single_param_find_by_hash) { { find_hash: { limit: 1 }, matches: 1 } }

    let(:multi_param_find_by_hash) do
      { find_hash: { limit: 2, offset: 0 }, matches: 1 }
    end
  end
end
