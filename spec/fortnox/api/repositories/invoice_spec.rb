require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/models/invoice'
require 'fortnox/api/repositories/all_examples'
require 'fortnox/api/repositories/find_examples'
require 'fortnox/api/repositories/save_examples'

describe Fortnox::API::Repository::Invoice do
  include_context 'repository context'

  it_behaves_like 'repositories', Fortnox::API::Model::Invoice

  include_examples '.all', Fortnox::API::Model::Invoice, 'invoices'

  include_examples '.find', Fortnox::API::Model::Invoice, :document_number, 'invoices'

  include_examples '.save', 'invoices', 'Invoice', :comments, 'Comments' do
    let( :attribute_value ){ 'An invoice comment' }
    let( :updated_attribute_value ){ 'An updated invoice comment' }
    let( :valid_model ) do
      Fortnox::API::Model::Invoice.new( comments: attribute_value,
                                        customer_number: 1 )
    end
  end
end
