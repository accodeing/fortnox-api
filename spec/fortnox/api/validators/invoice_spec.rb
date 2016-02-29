require 'spec_helper'
require 'fortnox/api/models/invoice'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/invoice'

describe Fortnox::API::Validator::Invoice do
  let( :model_class ){ Fortnox::API::Model::Invoice }

  include_context 'validator context' do
    let( :valid_model ){ model_class.new( customer_number: 12345 ) }
  end

  describe '.validate Invoice' do
    include_examples 'required attributes', Fortnox::API::Model::Invoice

    include_examples 'validates length of string', :address1, 1024
    include_examples 'validates length of string', :address2, 1024
    include_examples 'validates length of string', :customer_name, 1024
    include_examples 'validates length of string', :external_invoice_reference1, 80
    include_examples 'validates length of string', :external_invoice_reference2, 80
    include_examples 'validates length of string', :our_reference, 50
    include_examples 'validates length of string', :phone1, 1024
    include_examples 'validates length of string', :phone2, 1024
    include_examples 'validates length of string', :remarks, 1024
    include_examples 'validates length of string', :your_order_number, 30
    include_examples 'validates length of string', :your_reference, 50
    include_examples 'validates length of string', :zip_code, 1024

    include_examples 'validates inclusion of number', :administration_fee, 0, 99_999_999_999.0
    include_examples 'validates inclusion of number', :currency_rate, 0, 999_999_999_999_999.0
    include_examples 'validates inclusion of number', :currency_unit, 0, 999_999_999_999_999.0
    include_examples 'validates inclusion of number', :freight, 0, 99_999_999_999.0
  end
end
