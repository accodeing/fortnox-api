require 'spec_helper'
require 'fortnox/api/models/customer'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/customer'

describe Fortnox::API::Validator::Customer do
  subject{ described_class.new }

  include_context 'validator context' do
    let( :valid_model ) do
      Fortnox::API::Model::Customer.new( name: 'A customer' )
    end
  end

  describe '.validate Customer' do
   include_examples 'required attributes', Fortnox::API::Model::Customer

   include_examples 'validates inclusion of number', :sales_account, 0, 9999.0

   include_examples 'validates inclusion of string', :type, described_class::TYPES
   include_examples 'validates inclusion of string', :vat_type, described_class::VAT_TYPES
   include_examples 'validates inclusion of string',
                    :country_code,
                    described_class::COUNTRY_CODES,
                    'aaa'
   include_examples 'validates inclusion of string',
                    :currency,
                    described_class::CURRENCIES,
                    '-_-'
  end
end
