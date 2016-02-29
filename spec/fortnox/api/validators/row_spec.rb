require 'spec_helper'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/row'
require 'fortnox/api/models/row'

describe Fortnox::API::Validator::Row do
  include_context 'validator context' do
    let( :valid_model ){ Fortnox::API::Model::Row.new }
  end

  describe '.validate Row' do
    context 'with required attributes' do
      it{ is_expected.to be_valid( valid_model ) }
    end

    include_examples 'validates length of string', :article_number, 50
    include_examples 'validates length of string', :description, 50

    include_examples 'validates inclusion of number', :account_number, 0, 9999
    include_examples 'validates inclusion of number', :delivered_quantity, 0, 9_999_999_999_999.0
    include_examples 'validates inclusion of number', :discount, 0, 99_999_999_999.0
    include_examples 'validates inclusion of number', :house_work_hours_to_report, 0, 99_999
    include_examples 'validates inclusion of number', :price, 0, 99_999_999_999.0
  end
end
