require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/project'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'

describe Fortnox::API::Repository::Project, order: :defined, integration: true do
  subject( :repository ){ described_class.new }

  include_examples '.save',
                   :comments,
                   additional_attrs: { description: 'Some important project' }

  # It is not yet possible to delete Projects. Therefore, expected nr of
  # Projects when running .all will continue to increase
  # (until 100, which is max by default).
  include_examples '.all', 8

  include_examples '.find', '1' do
    let( :find_by_hash_failure ){ { offset: 10000 } }
    let( :single_param_find_by_hash ){ { find_hash: { limit: 1 }, matches: 1 } }

    let( :multi_param_find_by_hash ) do
      { find_hash: { limit: 2, offset: 2 }, matches: 2 }
    end
  end
end
