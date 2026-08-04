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

  describe '.save with labels' do
    let(:labels) do
      [
        Fortnox::Label.stub(id: 1, description: 'TestLabel'),
        Fortnox::Label.stub(id: 2, description: 'LabelSpec2')
      ]
    end
    let(:new_model) do
      described_class.stub(customer_number: '1', comments: 'Order with labels', labels: labels)
    end
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/save_new_with_labels") do
        described_class.save(new_model)
      end
    end

    it 'serialises labels as plain hashes without wrapper' do
      expect { response }.not_to raise_error
    end

    it 'round-trips the labels', :aggregate_failures do
      returned_labels = response.model.labels
      expect(returned_labels.map(&:id)).to eq([1, 2])
    end
  end

  describe '.save with nested model' do
    let(:nested_model_hash) { { price: -7_999_999_999, article_number: '101', ordered_quantity: 1 } }
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
      expect { response }.not_to raise_error
    end

    describe "returned entity's nested model" do
      subject(:returned_nested_model) { response.model.order_rows.first }

      it 'has the wanted attributes', :aggregate_failures do
        nested_model_hash.each do |attribute, value|
          expect(returned_nested_model.send(attribute)).to eq(value)
        end
      end
    end
  end

  describe '.save with all writable attributes' do
    # Excludes housework + housework_type on rows — covered by housework_types_spec.
    let(:row_attributes) do
      {
        account_number: 3001,
        article_number: '101',
        cost_center: '1',
        delivered_quantity: 1.0,
        description: 'Row description',
        discount: 0.0,
        discount_type: 'PERCENT',
        ordered_quantity: 1.0,
        price: 100.0,
        project: '1',
        unit: 'blarg10',
        vat: 25
      }
    end
    let(:writable_attributes) do
      {
        customer_number: '1',
        administration_fee: 50.0,
        address1: 'Storgatan 1',
        address2: 'Box 100',
        city: 'Stockholm',
        comments: 'A fully populated order',
        copy_remarks: true,
        cost_center: '1',
        country_code: 'SE',
        currency: 'SEK',
        currency_rate: 1.0,
        currency_unit: 1.0,
        customer_name: 'Customer with IDN email',
        delivery_address1: 'Leveransvägen 2',
        delivery_address2: 'Port B',
        delivery_city: 'Göteborg',
        delivery_country: 'SE',
        delivery_date: Date.new(2026, 6, 1),
        delivery_name: 'Delivery Recipient',
        delivery_state: 'delivery',
        delivery_zip_code: '41100',
        email_information: Fortnox::Structs::EmailInformation.new(
          email_address_to: 'order@example.com',
          email_address_cc: 'order-cc@example.com',
          email_address_bcc: 'order-bcc@example.com',
          email_subject: 'Order {no}',
          email_body: 'Body'
        ),
        external_invoice_reference1: 'EXT-1',
        external_invoice_reference2: 'EXT-2',
        freight: 25.0,
        language: 'SV',
        not_completed: false,
        order_date: Date.new(2026, 5, 1),
        our_reference: 'Bilbo',
        outbound_date: Date.new(2026, 5, 15),
        phone1: '+46 8 4444444',
        phone2: '+46 8 5555555',
        price_list: 'A',
        print_template: 'oc',
        project: '1',
        remarks: 'Some remarks',
        tax_reduction_type: 'none',
        terms_of_delivery: 'FVL',
        terms_of_payment: '30',
        vat_included: false,
        way_of_delivery: 'P',
        your_order_number: 'YO-1',
        your_reference: 'Frodo',
        zip_code: '11122'
      }
    end
    let(:label_ids) { [1, 2] }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new_fully_populated") do
        described_class.save(
          described_class.stub(
            **writable_attributes,
            labels: label_ids.map { |id| Fortnox::Label.stub(id: id) },
            order_rows: [Fortnox::Structs::OrderRow.new(row_attributes)]
          )
        )
      end
    end

    it 'round-trips every writable attribute', :aggregate_failures do
      writable_attributes.each do |attribute, value|
        expect(save_new.model.send(attribute)).to eq(value)
      end
    end

    it 'round-trips the labels' do
      expect(save_new.model.labels.map(&:id)).to eq(label_ids)
    end

    it 'round-trips every writable row attribute', :aggregate_failures do
      returned_row = save_new.model.order_rows.first
      row_attributes.each do |attribute, value|
        expect(returned_row.send(attribute)).to eq(value)
      end
    end
  end

  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { described_class.all }
    end

    it 'returns a non-empty collection' do
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
          expect { find_with_non_existing_id }.to raise_error(Fortnox::RequestError)
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

        it 'returns an empty collection' do
          expect(find_failure).to be_empty
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

      it { is_expected.to be_a(Fortnox::Collection) }
      it { is_expected.to be_empty }
    end

    context 'with matches' do
      subject(:results) do
        VCR.use_cassette("#{vcr_dir}/search_by_name") do
          described_class.search(customername: 'customer')
        end
      end

      it { is_expected.to be_a(Fortnox::Collection) }

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

      it { is_expected.to be_a(Fortnox::Collection) }

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
        expect { only_with_invalid_filter }.to raise_error(Fortnox::RequestError)
      end
    end
  end
end
