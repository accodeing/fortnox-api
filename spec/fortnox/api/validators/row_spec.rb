require 'spec_helper'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/row'
require 'fortnox/api/models/row'

describe Fortnox::API::Validator::Row do
  let( :model_class ){ Fortnox::API::Model::Row }
  let( :valid_model ){ model_class.new }

  include_context 'validator context'

  describe '.validate Row' do
    context 'with required attributes' do
      it{ is_expected.to be_valid( valid_model ) }
    end

    include_examples 'validates length of string', :article_number, 50
    include_examples 'validates length of string', :description, 50

    context 'with valid attributes' do
      it_behaves_like 'valid', :delivered_quantity, [0, 12345678901234]
      it_behaves_like 'valid', :discount, [0, 123456789012]
      it_behaves_like 'valid', :house_work_hours_to_report, [0, 12345]
      it_behaves_like 'valid', :price, [0, 123456789012]
    end

    context 'with invalid attributes' do
      it_behaves_like 'invalid', :account_number, [-1, 12345], :inclusion
      it_behaves_like 'invalid', :delivered_quantity, [-1, 123456789012345], :inclusion
      it_behaves_like 'invalid', :discount, [-1, 1234567890123], :inclusion
      it_behaves_like 'invalid', :house_work_hours_to_report, [-1, 123456], :inclusion
      it_behaves_like 'invalid', :price, [-1, 1234567890123], :inclusion
    end
  end
end
