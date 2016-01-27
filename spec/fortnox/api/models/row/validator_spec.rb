require 'spec_helper'
require 'fortnox/api/models/row/validator'
require 'fortnox/api/models/row/entity'

describe Fortnox::API::Validators::Row do
  let( :entity_class ){ Fortnox::API::Entities::Row }

  subject { described_class.new( entity ) }

  shared_examples_for 'invalid' do |attribute, values|
    values.each do |value|
      let( :entity ){ entity_class.new( attribute => value ) }

      it { is_expected.to validate_false( entity ) }
      it { is_expected.to include_error_for( attribute, 1 ) }
    end
  end

  shared_examples_for 'valid' do |attribute, values|
    values.each do |value|
      let( :entity ){ entity_class.new( attribute => value ) }

      it { is_expected.to validate_true( entity ) }
    end
  end

  describe '.validate Row with' do
    context 'required attributes' do
      let( :entity ){ entity_class.new }

      it { is_expected.to validate_true( entity ) }
    end

    context 'valid' do
      context 'article_number' do
        it_behaves_like 'valid', :article_number, ['', 'a', 'a' * 49, 'a' * 50]
      end

      context 'delivered_quantity' do
        it_behaves_like 'valid', :delivered_quantity, [0, 12345678901234]
      end

      context 'description' do
        it_behaves_like 'valid', :description, ['', 'a', 'a' * 49, 'a' * 50]
      end

      context 'discount' do
        it_behaves_like 'valid', :discount, [0, 123456789012]
      end

      context 'house_work_hours_to_report' do
        it_behaves_like 'valid', :house_work_hours_to_report, [0, 12345]
      end

      context 'price' do
        it_behaves_like 'valid', :price, [0, 123456789012]
      end
    end

    context 'invalid' do
      context 'account_number' do
        it_behaves_like 'invalid', :account_number, [12345]
      end

      context 'article_number' do
        it_behaves_like 'invalid', :article_number, ['a' * 51]
      end

      context 'delivered_quantity' do
        it_behaves_like 'invalid', :delivered_quantity, [123456789012345]
      end

      context 'description' do
        it_behaves_like 'invalid', :description, ['a' * 51]
      end

      context 'discount' do
        it_behaves_like 'invalid', :discount, [1234567890123]
      end

      context 'house_work_hours_to_report' do
        it_behaves_like 'invalid', :house_work_hours_to_report, [123456]
      end

      context 'price' do
        it_behaves_like 'invalid', :price, [1234567890123]
      end
    end
  end
end
