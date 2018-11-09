# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/metadata'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Metadata do
  key_map = Fortnox::API::Mapper::Metadata::KEY_MAP
  json_entity_type = 'MetaInformation'

  it_behaves_like 'mapper', key_map, json_entity_type, nil do
    let(:mapper) { described_class.new }
  end
end
