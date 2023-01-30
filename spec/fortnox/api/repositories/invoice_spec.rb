# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/search'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_nested_model'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/only'

describe Fortnox::API::Repository::Invoice, integration: true, order: :defined do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  required_hash = { customer_number: '1' }

  include_examples '.save', :comments, additional_attrs: required_hash

  describe '#save' do
    context 'with unsaved parent' do
      subject(:saved_child) do
        parent_invoice = Fortnox::API::Model::Invoice.new(customer_number: '1')
        child_invoice = parent_invoice.update(due_date: '2023-01-01')

        VCR.use_cassette("#{vcr_dir}/save_new_with_unsaved_parent") do
          described_class.new.save(child_invoice)
        end
      end

      it 'sets attribute from parent when saved' do
        expect(saved_child.customer_number).to eq '1'
      end
    end
  end

  nested_model_hash = { price: 10, article_number: '101' }
  include_examples '.save with nested model',
                   required_hash,
                   :invoice_rows,
                   nested_model_hash,
                   [Fortnox::API::Types::InvoiceRow.new(nested_model_hash)]

  include_examples '.save with specially named attribute',
                   required_hash,
                   :ocr,
                   '426523791'

  # It is not possible to delete Invoces. Therefore, expected nr of Orders
  # when running .all will continue to increase (until 100, which is max by default).
  include_examples '.all', 32

  # VCR: Models needs to be created manually in Fortnox
  include_examples '.find', 1 do
    let(:find_by_hash_failure) { { yourreference: 'Not found' } }

    let(:single_param_find_by_hash) do
      { find_hash: { yourreference: 'Gandalf the Grey' }, matches: 2 }
    end
    let(:multi_param_find_by_hash) do
      { find_hash: { yourreference: 'Gandalf the Grey', ourreference: 'Radagast the Brown' },
        matches: 1 }
    end
  end

  include_examples '.search', :customername, 'Test', 1

  # VCR: Need to be set manually in Fortnox
  include_examples '.only', :fullypaid, 2

  describe 'country attribute' do
    def new_invoice(country:)
      described_class::MODEL.new(customer_number: 1, country: country)
    end

    context 'with valid country' do
      def save_invoice(country:, vcr_cassette: country)
        VCR.use_cassette("#{vcr_dir}/save_new_with_country_#{vcr_cassette}") do
          repository.save(new_invoice(country: country))
        end
      end

      it 'accepts English country names' do
        expect(save_invoice(country: 'Norway').country).to eq('NO')
      end

      it 'translates Swedish country names to English' do
        expect(save_invoice(country: 'Norge').country).to eq('NO')
      end

      it 'skips nil values' do
        expect(save_invoice(country: nil, vcr_cassette: 'nil').country).to eq('')
      end

      it 'skips empty string values' do
        expect(save_invoice(country: '', vcr_cassette: 'empty_string').country).to eq('')
      end

      describe 'GB' do
        subject { save_invoice(country: 'GB').country }

        it { is_expected.to eq('GB') }
      end

      describe 'VA' do
        subject { save_invoice(country: 'VA').country }

        it { is_expected.to eq('VA') }
      end

      describe 'VI' do
        subject { save_invoice(country: 'VI').country }

        it { is_expected.to eq('VI') }
      end

      describe 'special cases Sverige' do
        subject { save_invoice(country: 'Sverige').country }

        it { is_expected.to eq('SE') }
      end
    end
  end

  describe 'resetting values in Fortnox' do
    context 'with String values' do
      def new_invoice(comments:)
        described_class::MODEL.new(customer_number: 1, comments: comments)
      end

      let(:persisted_invoice) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_comments") do
          repository.save(new_invoice(comments: 'A comment to be reset'))
        end
      end

      before { persisted_invoice }

      context 'when setting value to nil' do
        subject(:comments) { updated_persisted_invoice.comments }

        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_nil_comments") do
            repository.save(persisted_invoice.update(comments: nil))
          end
        end

        it do
          pending "test to rerecord VCR cassette, maybe it's working now"
          expect(comments).to be_nil
        end
      end

      context 'when setting value to empty string' do
        subject(:comments) { updated_persisted_invoice.comments }

        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_empty_comments") do
            repository.save(persisted_invoice.update(comments: ''))
          end
        end

        it 'does not reset the value' do
          expect(comments).to eq('A comment to be reset')
        end
      end
    end

    context 'with other values' do
      def new_invoice(country:)
        described_class::MODEL.new(customer_number: 1, country: country)
      end

      let(:persisted_invoice) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_country") do
          repository.save(new_invoice(country: 'Sverige'))
        end
      end

      before { persisted_invoice }

      context 'when setting value to nil' do
        subject(:country) { updated_persisted_invoice.country }

        let(:updated_persisted_invoice) do
          # TODO: This VCR cassette needs to be re-recorded again
          # when the we fix #172.
          VCR.use_cassette("#{vcr_dir}/save_old_with_nil_country") do
            repository.save(persisted_invoice.update(country: nil))
          end
        end

        it 'is nil' do
          pending 'see comment above'
          expect(country).to be_nil
        end
      end

      context 'when setting value to empty string' do
        subject(:country) { updated_persisted_invoice.country }

        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_empty_country") do
            repository.save(persisted_invoice.update(country: ''))
          end
        end

        it 'does not reset the country' do
          expect(country).to eq('SE')
        end
      end
    end
  end

  describe 'limits for invoice_row' do
    describe 'description' do
      let(:model) do
        described_class::MODEL.new(
          customer_number: '1',
          invoice_rows: [
            {
              article_number: '101',
              description: 'a' * 255
            }
          ]
        )
      end
      let(:saving_with_max_row_description) do
        VCR.use_cassette("#{vcr_dir}/row_description_limit") { repository.save(model) }
      end

      it 'allows 255 characters' do
        expect { saving_with_max_row_description }.not_to raise_error
      end
    end
  end
end
