# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Order, order: :defined do
  let(:vcr_dir) { 'orders' }

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
    let(:nested_model_hash) { { price: -9_999_999_999, article_number: '101', ordered_quantity: 1 } }
    let(:new_model) do
      described_class.stub(
        customer_number: '1',
        order_rows: [Fortnox::Structs::OrderRow.new(nested_model_hash)]
      )
    end
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/save_with_nested_model") do
        described_class.save(new_model)
      end
    end

    it 'does not raise any errors' do
      pending 'Negative price exceeds Fortnox limit after VAT calculation'
      expect { response }.not_to raise_error
    end

    describe "returned entity's nested model" do
      subject(:returned_nested_model) { response.model.order_rows.first }

      it 'has the wanted attributes', :aggregate_failures do
        pending 'Negative price exceeds Fortnox limit after VAT calculation'
        expect(returned_nested_model.article_number).to eq('101')
        expect(returned_nested_model.ordered_quantity).to eq(1.0)
      end
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
          it 'returns matching orders', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
            VCR.use_cassette("#{vcr_dir}/single_param_find_by_hash") do
              results = described_class.find(ourreference: 'Belladonna Took')
              expect(results).not_to be_empty

              results.each do |result|
                full = described_class.find(result.model.document_number)
                expect(full.model.our_reference).to eq('Belladonna Took')
              end
            end
          end
        end

        context 'with multiple parameters' do
          it 'returns matching orders', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
            VCR.use_cassette("#{vcr_dir}/multi_param_find_by_hash") do
              results = described_class.find(ourreference: 'Belladonna Took', yourreference: 'Bodo Proudfoot')
              expect(results).not_to be_empty

              results.each do |result|
                full = described_class.find(result.model.document_number)
                expect(full.model.our_reference).to eq('Belladonna Took')
                expect(full.model.your_reference).to eq('Bodo Proudfoot')
              end
            end
          end
        end
      end

      context 'when not found' do
        let(:find_failure) do
          VCR.use_cassette("#{vcr_dir}/find_by_hash_failure") do
            described_class.find(ourreference: 'Not found')
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

      it 'returns matching orders', :aggregate_failures do
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
        VCR.use_cassette("#{vcr_dir}/filter_hit") { described_class.only(:cancelled) }
      end

      it { is_expected.to be_instance_of(Array) }

      it 'returns cancelled orders', :aggregate_failures do
        expect(results).not_to be_empty
        expect(results).to all(satisfy { |result| result.model.cancelled == true })
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
end
