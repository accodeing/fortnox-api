# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Article, order: :defined do
  let(:vcr_dir) { 'articles' }

  describe '.save' do
    let(:new_model) { described_class.stub(description: 'A value', sales_account: 1250) }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") { described_class.save(new_model) }
    end

    describe 'new' do
      it 'saves with correct description' do
        expect(save_new.model.description).to eq('A value')
      end
    end

    describe 'old (update existing)' do
      let(:existing_model) do
        VCR.use_cassette("#{vcr_dir}/find_new") do
          described_class.find(save_new.model.article_number)
        end
      end

      let(:updated_model) { existing_model.update(description: 'Updated description') }

      let(:save_old) do
        VCR.use_cassette("#{vcr_dir}/save_old") { described_class.save(updated_model) }
      end

      it 'updates with correct description' do
        expect(save_old.model.description).to eq('Updated description')
      end
    end
  end

  describe '.save with specially named attribute' do
    let(:new_model) { described_class.stub(description: 'Test article', ean: '5901234123457') }
    let(:save_model) do
      VCR.use_cassette("#{vcr_dir}/save_with_specially_named_attribute") do
        described_class.save(new_model)
      end
    end

    it 'does not raise any errors' do
      expect { save_model }.not_to raise_error
    end

    it 'returns the correct value' do
      expect(save_model.model.ean).to eq('5901234123457')
    end
  end

  describe '.save with all writable attributes' do
    # Excludes housework + housework_type — covered by housework_types_spec.
    # Excludes default_stock_point + default_stock_location — require existing
    # stock points configured in the tenant.
    # Excludes cost_calculation_method — Fortnox silently drops the value
    # despite stock accounting being enabled.
    # Excludes direct_cost, freight_cost, other_cost — when set together with
    # purchase_price, Fortnox overrides purchase_price with their sum.
    # Excludes quantity_in_stock — for stock_goods=true articles, Fortnox
    # derives this from inventory transactions and ignores the value sent.
    # The limits specs below exercise it for stock_goods=false articles.
    # NOTE: Bump article_number when re-recording VCR cassettes — Fortnox rejects duplicates
    let(:fully_populated_article_number) { 'FULL6' }
    let(:writable_attributes) do
      {
        article_number: fully_populated_article_number,
        active: true,
        bulky: true,
        construction_account: 3001,
        depth: 100,
        description: 'A fully populated article',
        ean: '5901234123457',
        eu_account: 3108,
        eu_vat_account: 3106,
        expired: false,
        export_account: 3105,
        height: 200,
        manufacturer: 'Acme Tools',
        manufacturer_article_number: 'ACME-001',
        note: 'Some notes',
        purchase_account: 4000,
        purchase_price: 100.0,
        sales_account: 3001,
        stock_account: 1410,
        stock_change_account: 4960,
        stock_goods: true,
        stock_place: 'Aisle 3',
        stock_warning: 5.0,
        supplier_number: '1',
        type: 'STOCK',
        unit: 'blarg10',
        vat: 25.0,
        webshop_article: true,
        weight: 500,
        width: 300
      }
    end
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new_fully_populated") do
        described_class.save(described_class.stub(**writable_attributes))
      end
    end

    it 'round-trips every writable attribute', :aggregate_failures do
      writable_attributes.each do |attribute, value|
        expect(save_new.model.send(attribute)).to eq(value)
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
        VCR.use_cassette("#{vcr_dir}/find_by_id") { described_class.find('101') }
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
          expect(returned_object.unique_id).to eq '101'
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
              described_class.find(articlenumber: 101)
            end
          end

          it 'returns matching articles', :aggregate_failures do
            expect(returned_array).not_to be_empty
            expect(returned_array).to all(satisfy { |result| result.model.article_number == '101' })
          end
        end

        context 'with multiple parameters' do
          let(:returned_array) do
            VCR.use_cassette("#{vcr_dir}/multi_param_find_by_hash") do
              described_class.find(articlenumber: 101, description: 'Hammer')
            end
          end

          it 'returns matching articles', :aggregate_failures do
            expect(returned_array).not_to be_empty
            expect(returned_array).to all(satisfy { |result|
              result.model.article_number == '101' && result.model.description == 'Hammer'
            })
          end
        end
      end

      context 'when not found' do
        let(:find_failure) do
          VCR.use_cassette("#{vcr_dir}/find_by_hash_failure") do
            described_class.find(description: 'Not Found')
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
          described_class.search(description: 'nothing')
        end
      end

      it { is_expected.to be_a(Fortnox::Collection) }
      it { is_expected.to be_empty }
    end

    context 'with matches' do
      subject(:results) do
        VCR.use_cassette("#{vcr_dir}/search_by_name") do
          described_class.search(description: 'Test article')
        end
      end

      it { is_expected.to be_a(Fortnox::Collection) }

      it 'returns matching articles', :aggregate_failures do
        expect(results).not_to be_empty
        expect(results).to all(satisfy { |result| result.model.description.include?('Test article') })
      end
    end

    context 'with special characters' do
      let(:search_with_special_char) do
        VCR.use_cassette("#{vcr_dir}/search_with_special_char") do
          described_class.search(description: 'special char å')
        end
      end

      it 'does not raise an error' do
        expect { search_with_special_char }.not_to raise_error
      end
    end
  end

  describe 'limits' do
    describe 'quantity_in_stock' do
      let(:article) do
        VCR.use_cassette("#{vcr_dir}/limits/quantity_in_stock_min_value") do
          described_class.save(
            described_class.stub(description: 'Test article', quantity_in_stock: -99_999_999_999_999.9)
          )
        end
      end

      it 'has a lower limit' do
        expect(article.model.quantity_in_stock).to eq(-100_000_000_000_000.0)
      end

      context 'when positive' do
        let(:article) do
          VCR.use_cassette("#{vcr_dir}/limits/quantity_in_stock_rounding_positive_value") do
            described_class.save(
              described_class.stub(description: 'Test article', quantity_in_stock: 1.123)
            )
          end
        end

        it 'rounds to two decimals' do
          expect(article.model.quantity_in_stock).to eq(1.12)
        end
      end
    end
  end
end
