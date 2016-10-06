require 'spec_helper'
require 'fortnox/api/mappers/base'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Base do
  it_behaves_like 'mapper', nil, nil, nil, check_constants: false
end
