require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/models/invoice'

describe Fortnox::API::Repository::Invoice do

  include_context 'repository context' do
    let( :model_class ){ Fortnox::API::Model::Invoice }
  end

  include_examples '#save', 'Invoice'
end
