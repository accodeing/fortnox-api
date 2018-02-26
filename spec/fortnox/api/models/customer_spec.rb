# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/models/customer'
require 'fortnox/api/models/examples/model'

describe Fortnox::API::Model::Customer, type: :model do
  it_behaves_like 'a model', '1'
end
