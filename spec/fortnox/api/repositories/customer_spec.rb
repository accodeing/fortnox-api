require 'spec_helper'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'

describe Fortnox::API::Repository::Customer do
  include_context 'environment'

  include_examples '.all'

  include_examples '.find'

  include_examples '.save', :name do
    let( :value ){ 'A customer' }
    let( :updated_value ){ 'Updated customer' }
    let( :model_hash ){ { name: value } }
  end
end
