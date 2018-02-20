# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/default_delivery_types'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::DefaultDeliveryTypes do
  key_map = {}

  it_behaves_like 'mapper', key_map do
    let(:mapper) { described_class.new }
  end
end
