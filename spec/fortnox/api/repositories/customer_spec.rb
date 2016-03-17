require 'spec_helper'
require 'fortnox/api/repositories/environment_context'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all_examples'
require 'fortnox/api/repositories/examples/find_examples'
require 'fortnox/api/repositories/examples/save_examples'

describe Fortnox::API::Repository::Customer do
  include_context 'environment context'

  include_examples '.all'

  include_examples '.find', :customer_number

  include_examples '.save', :name do
    let( :value ){ 'A customer' }
    let( :updated_value ){ 'Updated customer' }
    let( :model_hash ){ { name: value } }
  end
end
