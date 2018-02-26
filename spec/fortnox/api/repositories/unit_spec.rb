# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/unit'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'

describe Fortnox::API::Repository::Unit, order: :defined, integration: true do
  include Helpers::Configuration

  before { set_api_test_configuration }

  subject(:repository) { described_class.new }

  include_examples '.save',
                   :description,
                   additional_attrs: { code: 'blarg' }

  include_examples '.save with specially named attribute',
                   { description: 'Happy clouds' },
                   :code,
                   'woooh'

  include_examples '.all', 6
end
