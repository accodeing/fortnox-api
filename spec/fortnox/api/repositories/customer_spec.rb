require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all_examples'
require 'fortnox/api/repositories/examples/find_examples'
require 'fortnox/api/repositories/examples/save_examples'

describe Fortnox::API::Repository::Customer do
  include_context 'repository context'

  it_behaves_like 'repositories'

  include_examples '.all'

  include_examples '.find', :customer_number

  include_examples '.save', :name, 'Name' do
    let( :attribute_value ){ 'A customer' }
    let( :updated_attribute_value ){ 'Updated customer' }
    let( :valid_model ){ described_class::MODEL.new( name: attribute_value ) }
  end
end
