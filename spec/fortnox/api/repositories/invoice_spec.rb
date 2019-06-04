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

describe Fortnox::API::Repository::Invoice, order: :defined, integration: true do
  include Helpers::Configuration

  before { set_api_test_configuration }

  subject(:repository) { described_class.new }

  required_hash = { customer_number: '1' }

  include_examples '.save', :comments, additional_attrs: required_hash

  nested_model_hash = { price: 10, article_number: '0000' }
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
  include_examples '.all', 97

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

  include_examples '.search', :customername, 'Test', 7

  include_examples '.only', :fullypaid, 4

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
        # TODO: What should happen with nil value?
        expect(save_invoice(country: nil, vcr_cassette: 'nil').country).to eq('')
      end

      it 'skips empty string values' do
        # TODO: What should happen with empty string value?
        expect(save_invoice(country: '', vcr_cassette: 'empty_string').country).to eq('')
      end

      describe 'GB' do
        subject { save_invoice(country: 'GB').country }

        it { is_expected.to eq('GB') }
      end

      describe 'KR' do
        subject { save_invoice(country: 'KR').country }

        it { is_expected.to eq('KR') }
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

      context 'by setting value to nil' do
        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_nil_comments") do
            repository.save(persisted_invoice.update(comments: nil))
          end
        end

        subject { updated_persisted_invoice.comments }

        pending { is_expected.to eq(nil) }
      end

      context 'by setting value to empty string' do
        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_empty_comments") do
            repository.save(persisted_invoice.update(comments: ''))
          end
        end

        subject { updated_persisted_invoice.comments }

        it 'does not reset the value' do
          is_expected.to eq('A comment to be reset')
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

      context 'by setting value to nil' do
        let(:updated_persisted_invoice) do
          # TODO: This VCR cassette needs to be re-recorded again
          # when the we fix #172.
          VCR.use_cassette("#{vcr_dir}/save_old_with_nil_country") do
            repository.save(persisted_invoice.update(country: nil))
          end
        end

        subject { updated_persisted_invoice.country }

        pending { is_expected.to eq(nil) }
      end

      context 'by setting value to empty string' do
        let(:updated_persisted_invoice) do
          VCR.use_cassette("#{vcr_dir}/save_old_with_empty_country") do
            repository.save(persisted_invoice.update(country: ''))
          end
        end

        subject { updated_persisted_invoice.country }

        it 'does not reset the country' do
          is_expected.to eq('SE')
        end
      end
    end
  end
end
