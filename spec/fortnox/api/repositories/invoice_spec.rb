require 'spec_helper'
require 'fortnox/api/repositories/environment_context'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/repositories/examples/all_examples'
require 'fortnox/api/repositories/examples/find_examples'
require 'fortnox/api/repositories/examples/save_examples'

describe Fortnox::API::Repository::Invoice do
  include_context 'environment context'

  include_examples '.all'

  include_examples '.find'

  include_examples '.save', :comments do
    let( :value ){ 'An invoice comment' }
    let( :updated_value ){ 'An updated invoice comment' }
    let( :model_hash ){ { comments: value, customer_number: 1 } }
  end
end
