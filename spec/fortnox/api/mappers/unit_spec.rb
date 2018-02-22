require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/customer'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Unit do
  key_map = Fortnox::API::Mapper::Unit::KEY_MAP

  json_entity_type = 'Unit'
  json_entity_collection = 'Units'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper){ described_class.new }
  end
end
