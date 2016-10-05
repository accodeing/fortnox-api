require 'spec_helper'
require 'fortnox/api/mappers/base'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Base do
  key_map = { key_a: 'a', key_b: 'b' }
  json_entity_wrapper = 'SomeClass'
  json_collection_wrapper = 'SomeClasses'

  it_behaves_like 'mapper', key_map, json_entity_wrapper, json_collection_wrapper do
    let(:mapper){ described_class.new(key_map, json_entity_wrapper, json_collection_wrapper) }
  end
end
