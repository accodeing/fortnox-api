require 'spec_helper'
require 'fortnox/api/models/row/validator'
require 'fortnox/api/models/row/entity'

describe Fortnox::API::Validators::Row do
  let( :entity_class ){ Fortnox::API::Entities::Row }

  subject { described_class.new( entity ) }

  shared_examples_for 'invalid' do |attribute, value|
    let( :entity ){ entity_class.new( attribute => value ) }

    it { is_expected.to validate_false( entity ) }
    it { is_expected.to include_error_for( attribute, 1 ) }
  end

  shared_examples_for 'valid' do |attribute, value|
    let( :entity ){ entity_class.new( attribute => value ) }

    it { is_expected.to validate_true( entity ) }
  end

  describe '.validate Row with' do
    context 'required attributes' do
      let( :entity ){ entity_class.new }

      it { is_expected.to validate_true( entity ) }
    end

    context 'valid' do
      it_behaves_like 'valid', :article_number, 'a' * 50
      it_behaves_like 'valid', :article_number, 'a' * 49
      it_behaves_like 'valid', :article_number, 'a'
      it_behaves_like 'valid', :article_number, ''

      it_behaves_like 'valid', :delivered_quantity, 12345678901234

      it_behaves_like 'valid', :description, 'a' * 50
      it_behaves_like 'valid', :description, 'a' * 49
      it_behaves_like 'valid', :description, 'a'
      it_behaves_like 'valid', :description, ''
    end

    context 'invalid' do
      it_behaves_like 'invalid', :account_number, 12345

      it_behaves_like 'invalid', :article_number, 'a' * 51

      it_behaves_like 'invalid', :delivered_quantity, 123456789012345

      it_behaves_like 'invalid', :description, 'a' * 51
    end
  end
end
