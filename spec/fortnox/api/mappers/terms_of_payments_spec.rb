# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/terms_of_payments'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::TermsOfPayments do
  key_map = {}
  json_entity_type = 'TermsOfPayment'
  json_entity_collection = 'TermsOfPayments'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper) { described_class.new }
  end
end
