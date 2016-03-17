require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/models/invoice'
require 'fortnox/api/repositories/examples/all_examples'
require 'fortnox/api/repositories/examples/find_examples'
require 'fortnox/api/repositories/examples/save_examples'

describe Fortnox::API::Repository::Invoice do
  include_context 'repository context'

  it_behaves_like 'repositories'

  include_examples '.all'

  include_examples '.find', :document_number

  include_examples '.save', :comments, 'Comments' do
    let( :attribute_value ){ 'An invoice comment' }
    let( :updated_attribute_value ){ 'An updated invoice comment' }
    let( :valid_model ) do
      described_class::MODEL.new( comments: attribute_value,
                                  customer_number: 1 )
    end
  end
end
