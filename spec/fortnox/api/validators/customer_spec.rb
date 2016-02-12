require 'spec_helper'
require 'fortnox/api/models/customer'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/customer'

describe Fortnox::API::Validator::Customer do
  let( :model_class ){ Fortnox::API::Model::Customer }

  include_context 'validator context' do
    let( :valid_model ){ model_class.new( name: 'A customer' ) }
  end

  describe '.validate Customer' do
    include_examples 'required attributes', Fortnox::API::Model::Customer

    include_examples 'validates inclusion of number', :sales_account, 0, 9999.0

    TYPES = ['PRIVATE', 'COMPANY']
    VAT_TYPES = ['SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT']
    include_examples 'validates inclusion of string', :type, TYPES
    include_examples 'validates inclusion of string', :vat_type, VAT_TYPES
  end
end
