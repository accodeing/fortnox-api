require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/customer'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Article do
  key_map = Fortnox::API::Mapper::Article::KEY_MAP

  json_entity_type = 'Article'
  json_entity_collection = 'Articles'

  it_behaves_like 'mapper', key_map, json_entity_type, json_entity_collection do
    let(:mapper){ described_class.new }
  end
end
