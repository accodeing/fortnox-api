require 'spec_helper'
require 'fortnox/api/models/article'
require 'fortnox/api/models/examples/model'

describe Fortnox::API::Model::Article, type: :model do
  it_behaves_like 'a model', '1'
end
