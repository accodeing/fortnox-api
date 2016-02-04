require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/models/invoice'

describe Fortnox::API::Repository::Invoice do

  include_context 'repository context' do
    let( :model ){ Fortnox::API::Model::Invoice.new( unsaved: false ) }
    let( :repository ){ Fortnox::API::Repository::Invoice.new }
  end

  include_examples '#save', 'Invoice'
end
