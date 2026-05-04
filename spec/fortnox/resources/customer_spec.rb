# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Customer, order: :defined do
  let(:vcr_dir) { 'customers' }

  describe '.save' do
    let(:new_model) { described_class.stub(name: 'A value') }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") { described_class.save(new_model) }
    end

    describe 'new' do
      it 'saves with correct name' do
        expect(save_new.model.name).to eq('A value')
      end
    end

    describe 'old (update existing)' do
      let(:existing_model) do
        VCR.use_cassette("#{vcr_dir}/find_new") do
          described_class.find(save_new.model.customer_number)
        end
      end

      let(:updated_model) { existing_model.update(name: 'Updated name') }

      let(:save_old) do
        VCR.use_cassette("#{vcr_dir}/save_old") { described_class.save(updated_model) }
      end

      it 'updates with correct name' do
        expect(save_old.model.name).to eq('Updated name')
      end
    end
  end

  describe '.save with specially named attribute' do
    let(:new_model) { described_class.stub(name: 'Test customer', email_invoice_cc: 'test@example.com') }
    let(:save_model) do
      VCR.use_cassette("#{vcr_dir}/save_with_specially_named_attribute") do
        described_class.save(new_model)
      end
    end

    it 'does not raise any errors' do
      expect { save_model }.not_to raise_error
    end

    it 'returns the correct value' do
      expect(save_model.model.email_invoice_cc).to eq('test@example.com')
    end
  end

  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { described_class.all }
    end

    it 'returns a non-empty array' do
      expect(response).not_to be_empty
    end

    it 'returns correct class' do
      expect(response.first).to be_a(described_class)
    end
  end

  describe '.find' do
    describe 'by id' do
      let(:returned_object) do
        VCR.use_cassette("#{vcr_dir}/find_by_id") { described_class.find('1') }
      end

      context 'when found' do
        it 'is saved' do
          expect(returned_object.meta).to be_saved
        end

        it 'is not new' do
          expect(returned_object.meta).not_to be_new
        end

        it 'returns correct class' do
          expect(returned_object).to be_a(described_class)
        end

        it 'returns correct unique id' do
          expect(returned_object.unique_id).to eq '1'
        end
      end

      context 'when not found' do
        let(:find_with_non_existing_id) do
          VCR.use_cassette("#{vcr_dir}/find_failure") { described_class.find('123456789') }
        end

        it 'raises an error' do
          expect { find_with_non_existing_id }.to raise_error(Fortnox::RequestError)
        end
      end
    end

    describe 'by hash' do
      context 'when found' do
        context 'with single parameter' do
          let(:returned_array) do
            VCR.use_cassette("#{vcr_dir}/single_param_find_by_hash") do
              described_class.find(city: 'New York')
            end
          end

          it 'returns matching customers', :aggregate_failures do
            expect(returned_array).not_to be_empty
            expect(returned_array).to all(satisfy { |result| result.model.city == 'New York' })
          end
        end

        context 'with multiple parameters' do
          let(:returned_array) do
            VCR.use_cassette("#{vcr_dir}/multi_param_find_by_hash") do
              described_class.find(city: 'New York', zipcode: '10001')
            end
          end

          it 'returns matching customers', :aggregate_failures do
            expect(returned_array).not_to be_empty
            expect(returned_array).to all(satisfy { |result|
              result.model.city == 'New York' && result.model.zip_code == '10001'
            })
          end
        end
      end

      context 'when not found' do
        let(:find_failure) do
          VCR.use_cassette("#{vcr_dir}/find_by_hash_failure") do
            described_class.find(city: 'Not Found')
          end
        end

        it 'returns empty array' do
          expect(find_failure).to eq []
        end
      end
    end
  end

  describe '.search' do
    context 'with no matches' do
      subject do
        VCR.use_cassette("#{vcr_dir}/search_miss") do
          described_class.search(name: 'nothing')
        end
      end

      it { is_expected.to be_instance_of(Array) }
      it { is_expected.to be_empty }
    end

    context 'with matches' do
      subject(:results) do
        VCR.use_cassette("#{vcr_dir}/search_by_name") do
          described_class.search(name: 'Test')
        end
      end

      it { is_expected.to be_instance_of(Array) }

      it 'returns matching customers', :aggregate_failures do
        expect(results).not_to be_empty
        expect(results).to all(satisfy { |result| result.model.name.include?('Test') })
      end
    end

    context 'with special characters' do
      let(:search_with_special_char) do
        VCR.use_cassette("#{vcr_dir}/search_with_special_char") do
          described_class.search(name: 'special char å')
        end
      end

      it 'does not raise an error' do
        expect { search_with_special_char }.not_to raise_error
      end
    end
  end

  describe 'country reference' do
    describe "with valid country code 'SE'" do
      let(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_country_code_SE") do
          described_class.save(
            described_class.stub(name: 'Customer with Swedish country code', country_code: 'SE')
          )
        end
      end

      it 'has correct country code' do
        expect(customer.model.country_code).to eq('SE')
      end

      it 'has correct country' do
        expect(customer.model.country).to eq('Sverige')
      end
    end
  end

  describe 'sales account' do
    context 'when saving a Customer with a Sales Account set' do
      let(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_sales_account") do
          described_class.save(
            described_class.stub(name: 'Customer with Sales Account', sales_account: '3001')
          )
        end
      end

      context 'when fetching that Customer' do
        let(:fetched_customer) do
          VCR.use_cassette("#{vcr_dir}/find_with_sales_account") do
            described_class.find(customer.model.customer_number)
          end
        end

        it 'has correct sales account' do
          expect(fetched_customer.model.sales_account).to eq(3001)
        end
      end
    end
  end

  describe 'internationalized domain name email' do
    context 'when saving a Customer with an IDN email address' do
      let(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_idn_email") do
          described_class.save(
            described_class.stub(name: 'Customer with IDN email', email: 'user@teståäö.se')
          )
        end
      end

      it 'saves the email' do
        expect(customer.model.email).to eq('user@teståäö.se')
      end
    end
  end
end
