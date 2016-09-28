require 'spec_helper'
require 'fortnox/api/models/customer'

describe Fortnox::API::Model::Customer, type: :model do

  valid_hash = { name: 'Arthur Dent' }

  subject { described_class }

  it{ is_expected.to require_attribute( :name, valid_hash ) }
end
