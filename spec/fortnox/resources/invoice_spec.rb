# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Invoice, order: :defined do
  let(:vcr_dir) { 'invoices' }

  describe '.save' do
    let(:new_model) { described_class.stub(customer_number: '1', comments: 'A value') }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") { described_class.save(new_model) }
    end

    describe 'new' do
      it 'saves with correct comments' do
        expect(save_new.model.comments).to eq('A value')
      end
    end

    describe 'old (update existing)' do
      let(:existing_model) do
        VCR.use_cassette("#{vcr_dir}/find_new") do
          described_class.find(save_new.model.document_number)
        end
      end

      let(:updated_model) { existing_model.update(comments: 'Updated comments') }

      let(:save_old) do
        VCR.use_cassette("#{vcr_dir}/save_old") { described_class.save(updated_model) }
      end

      it 'updates with correct comments' do
        expect(save_old.model.comments).to eq('Updated comments')
      end
    end
  end

  describe '.save with nested model' do
    let(:nested_model_hash) { { price: 10, article_number: '101' } }
    let(:new_model) do
      described_class.stub(
        customer_number: '1',
        invoice_rows: [Fortnox::Structs::InvoiceRow.new(nested_model_hash)]
      )
    end
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/save_with_nested_model") do
        described_class.save(new_model)
      end
    end

    it 'does not raise any errors' do
      expect { response }.not_to raise_error
    end

    describe "returned entity's nested model" do
      subject(:returned_nested_model) { response.model.invoice_rows.first }

      it 'has the wanted attributes' do
        nested_model_hash.each do |attribute, value|
          expect(returned_nested_model.send(attribute)).to eq(value)
        end
      end
    end
  end

  describe '.save with specially named attribute' do
    let(:new_model) { described_class.stub(customer_number: '1', ocr: '426523791') }
    let(:save_model) do
      VCR.use_cassette("#{vcr_dir}/save_with_specially_named_attribute") do
        described_class.save(new_model)
      end
    end

    it 'does not raise any errors' do
      expect { save_model }.not_to raise_error
    end

    it 'returns the correct value' do
      expect(save_model.model.ocr).to eq('426523791')
    end
  end

  # It is not possible to delete Invoices. Therefore, expected number of Invoices
  # when running .all will continue to increase (until 100, which is max by default).
  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { described_class.all }
    end

    it 'returns correct number of records' do
      expect(response.size).to be >= 2
    end

    it 'returns correct class' do
      expect(response.first).to be_a(described_class)
    end
  end

  describe '.find' do
    describe 'by id' do
      let(:returned_object) do
        VCR.use_cassette("#{vcr_dir}/find_by_id") { described_class.find(1) }
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
          expect(returned_object.unique_id).to eq 1
        end
      end

      context 'when not found' do
        let(:find_with_non_existing_id) do
          VCR.use_cassette("#{vcr_dir}/find_failure") { described_class.find('123456789') }
        end

        it 'raises an error' do
          expect { find_with_non_existing_id }.to raise_error(RestEasy::Error)
        end
      end
    end

    describe 'by hash' do
      context 'when found' do
        context 'with single parameter' do
          it 'returns matching invoices', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
            VCR.use_cassette("#{vcr_dir}/single_param_find_by_hash") do
              results = described_class.find(yourreference: 'Gandalf the Grey')
              expect(results).not_to be_empty

              results.each do |result|
                full = described_class.find(result.model.document_number)
                expect(full.model.your_reference).to eq('Gandalf the Grey')
              end
            end
          end
        end

        context 'with multiple parameters' do
          it 'returns matching invoices', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
            VCR.use_cassette("#{vcr_dir}/multi_param_find_by_hash") do
              results = described_class.find(yourreference: 'Gandalf the Grey', ourreference: 'Radagast the Brown')
              expect(results).not_to be_empty

              results.each do |result|
                full = described_class.find(result.model.document_number)
                expect(full.model.your_reference).to eq('Gandalf the Grey')
                expect(full.model.our_reference).to eq('Radagast the Brown')
              end
            end
          end
        end
      end

      context 'when not found' do
        let(:find_failure) do
          VCR.use_cassette("#{vcr_dir}/find_by_hash_failure") do
            described_class.find(yourreference: 'Not found')
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
          described_class.search(customername: 'nothing')
        end
      end

      it { is_expected.to be_instance_of(Array) }
      it { is_expected.to be_empty }
    end

    context 'with matches' do
      subject(:results) do
        VCR.use_cassette("#{vcr_dir}/search_by_name") do
          described_class.search(customername: 'customer')
        end
      end

      it { is_expected.to be_instance_of(Array) }

      it 'returns matching invoices', :aggregate_failures do
        expect(results).not_to be_empty
        expect(results).to all(satisfy { |result| result.model.customer_name.downcase.include?('customer') })
      end
    end

    context 'with special characters' do
      let(:search_with_special_char) do
        VCR.use_cassette("#{vcr_dir}/search_with_special_char") do
          described_class.search(customername: 'special char å')
        end
      end

      it 'does not raise an error' do
        expect { search_with_special_char }.not_to raise_error
      end
    end
  end

  describe '.only' do
    context 'with matches' do
      subject(:results) do
        VCR.use_cassette("#{vcr_dir}/filter_hit") { described_class.only(:fullypaid) }
      end

      it { is_expected.to be_instance_of(Array) }

      it 'returns fully paid invoices', :aggregate_failures do
        expect(results).not_to be_empty
        expect(results).to all(satisfy { |result| result.model.balance == 0 })
      end
    end

    context 'with invalid filter' do
      let(:only_with_invalid_filter) do
        VCR.use_cassette("#{vcr_dir}/filter_invalid") { described_class.only('doesntexist') }
      end

      it 'raises an error' do
        expect { only_with_invalid_filter }.to raise_error(RestEasy::Error)
      end
    end
  end

  describe 'country attribute' do
    def new_invoice(country_code:)
      described_class.stub(customer_number: '1', country_code: country_code)
    end

    context 'with valid country' do
      def save_invoice(country_code:, vcr_cassette: country_code)
        VCR.use_cassette("#{vcr_dir}/save_new_with_country_#{vcr_cassette}") do
          described_class.save(new_invoice(country_code: country_code))
        end
      end

      it 'accepts English country names' do
        expect(save_invoice(country_code: 'NO').model.country_code).to eq('NO')
      end

      it 'skips nil values' do
        expect(save_invoice(country_code: nil, vcr_cassette: 'nil').model.country_code).to eq('')
      end

      it 'skips empty string values' do
        expect(save_invoice(country_code: '', vcr_cassette: 'empty_string').model.country_code).to eq('')
      end

      describe 'GB' do
        subject { save_invoice(country_code: 'GB').model.country_code }

        it { is_expected.to eq('GB') }
      end

      describe 'VA' do
        subject { save_invoice(country_code: 'VA').model.country_code }

        it { is_expected.to eq('VA') }
      end

      describe 'VI' do
        subject { save_invoice(country_code: 'VI').model.country_code }

        it { is_expected.to eq('VI') }
      end

      describe 'SE' do
        subject { save_invoice(country_code: 'SE').model.country_code }

        it { is_expected.to eq('SE') }
      end
    end
  end

  describe 'resetting values in Fortnox' do
    context 'with String values' do
      def new_invoice(comments:)
        described_class.stub(customer_number: '1', comments: comments)
      end

      let(:persisted_invoice) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_comments") do
          described_class.save(new_invoice(comments: 'A comment to be reset'))
        end
      end

      before { persisted_invoice }

      context 'when setting value to nil' do
        subject(:comments) { updated_persisted_invoice.model.comments }

        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_nil_comments") do
            described_class.save(persisted_invoice.update(comments: nil))
          end
        end

        it { is_expected.to be_nil }
      end

      context 'when setting value to empty string' do
        subject(:comments) { updated_persisted_invoice.model.comments }

        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_empty_comments") do
            described_class.save(persisted_invoice.update(comments: ''))
          end
        end

        it 'resets the value' do
          expect(comments).to be_nil
        end
      end
    end

    context 'with other values' do
      def new_invoice(country_code:)
        described_class.stub(customer_number: '1', country_code: country_code)
      end

      let(:persisted_invoice) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_country") do
          described_class.save(new_invoice(country_code: 'SE'))
        end
      end

      before { persisted_invoice }

      context 'when setting value to nil' do
        subject(:country_code) { updated_persisted_invoice.model.country_code }

        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_nil_country") do
            described_class.save(persisted_invoice.update(country_code: nil))
          end
        end

        it 'is replaced by Fortnox with the default value' do
          expect(country_code).to eq('SE')
        end
      end

      context 'when setting value to empty string' do
        subject(:country_code) { updated_persisted_invoice.model.country_code }

        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_empty_country") do
            described_class.save(persisted_invoice.update(country_code: ''))
          end
        end

        it 'is replaced by Fortnox with the default value' do
          expect(country_code).to eq('SE')
        end
      end
    end
  end

  describe 'limits for invoice_row' do
    describe 'description' do
      let(:model) do
        described_class.stub(
          customer_number: '1',
          invoice_rows: [
            Fortnox::Structs::InvoiceRow.new(
              article_number: '101',
              description: 'a' * 255
            )
          ]
        )
      end
      let(:saving_with_max_row_description) do
        VCR.use_cassette("#{vcr_dir}/row_description_limit") { described_class.save(model) }
      end

      it 'allows 255 characters' do
        expect { saving_with_max_row_description }.not_to raise_error
      end
    end

    describe 'delivered_quantity' do
      let(:invoice) do
        model = described_class.stub(
          customer_number: '1',
          invoice_rows: [
            Fortnox::Structs::InvoiceRow.new(
              article_number: '101',
              description: 'Test',
              delivered_quantity: delivered_quantity
            )
          ]
        )
        VCR.use_cassette("#{vcr_dir}/#{cassette}") { described_class.save(model) }
      end

      context 'with three decimals' do
        let(:cassette) { 'row_delivered_quantity_decimals' }
        let(:delivered_quantity) { 1.123 }

        it 'rounds to two decimals' do
          expect(invoice.model.invoice_rows.first.delivered_quantity).to eq 1.12
        end
      end

      context 'when third decimal is 5' do
        let(:cassette) { 'row_delivered_quantity_decimals_round_up' }
        let(:delivered_quantity) { 1.125 }

        it 'rounds up' do
          expect(invoice.model.invoice_rows.first.delivered_quantity).to eq 1.13
        end
      end
    end

    describe 'price' do
      let(:invoice) do
        model = described_class.stub(
          customer_number: '1',
          invoice_rows: [
            Fortnox::Structs::InvoiceRow.new(
              article_number: '101',
              description: 'Test',
              price: price
            )
          ]
        )
        VCR.use_cassette("#{vcr_dir}/#{cassette}") { described_class.save(model) }
      end

      context 'with three decimals' do
        let(:cassette) { 'row_price_limit' }
        let(:price) { 1.123 }

        it 'rounds to two decimals' do
          expect(invoice.model.invoice_rows.first.price).to eq 1.12
        end
      end

      context 'when third decimal is 5' do
        let(:cassette) { 'row_price_limit_round_up' }
        let(:price) { 1.125 }

        it 'rounds up' do
          expect(invoice.model.invoice_rows.first.price).to eq 1.13
        end
      end
    end
  end
end
