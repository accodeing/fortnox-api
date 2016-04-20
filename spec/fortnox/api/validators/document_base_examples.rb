require 'spec_helper'
require 'fortnox/api/validators/context'

shared_examples_for 'DocumentBase Validator' do |model_class|
  subject{ described_class.new }

  include_context 'validator context' do
    let( :valid_model ){ model_class.new( customer_number: 12345 ) }
  end

  describe '.validate model' do
    include_examples 'required attributes', model_class

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
