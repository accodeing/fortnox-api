require 'spec_helper'
require 'fortnox/api/models/customer'
require 'fortnox/api/models/examples/model'

describe Fortnox::API::Model::Customer, type: :model do
  valid_hash = { name: 'Arthur Dent' }

  subject{ described_class }

  it_behaves_like 'a model', valid_hash, :customer_number, '5'
end
