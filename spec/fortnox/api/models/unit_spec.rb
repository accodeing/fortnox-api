require 'spec_helper'
require 'fortnox/api/models/unit'
require 'fortnox/api/models/examples/model'

describe Fortnox::API::Model::Unit, type: :model do
  it_behaves_like 'a model', '1'
end
