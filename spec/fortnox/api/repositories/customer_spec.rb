# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'
require 'fortnox/api/repositories/examples/save_with_specially_named_attribute'
require 'fortnox/api/repositories/examples/search'

describe Fortnox::API::Repository::Customer, integration: true, order: :defined do
  include Helpers::Configuration
  include Helpers::Repositories

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  include_examples '.save', :name

  include_examples '.save with specially named attribute',
                   { name: 'Test customer' },
                   :email_invoice_cc,
                   'test@example.com'

  # VCR: It is not yet possible to delete Customers. Therefore, expected nr of
  # Customers when running .all will continue to increase
  # (until 100, which is max by default).
  include_examples '.all', 2

  # VCR: Searched Customers needs to be created manually
  include_examples '.find', '1' do
    let(:find_by_hash_failure) { { city: 'Not Found' } }
    let(:single_param_find_by_hash) { { find_hash: { city: 'New York' }, matches: 2 } }

    let(:multi_param_find_by_hash) do
      { find_hash: { city: 'New York', zipcode: '10001' }, matches: 1 }
    end
  end

  # NOTE: When recording new VCR casettes, expected matches must be increased
  include_examples '.search', :name, 'Test', 2

  describe 'country reference' do
    describe 'with valid country code \'SE\'' do
      subject(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_country_code_SE") do
          repository.save(
            described_class::MODEL.new(
              name: 'Customer with Swedish country code',
              country_code: 'SE'
            )
          )
        end
      end

      describe 'country code' do
        subject { customer.country_code }

        it { is_expected.to eq('SE') }
      end

      describe 'country' do
        subject { customer.country }

        it { is_expected.to eq('Sverige') }
      end
    end
  end

  describe 'sales account' do
    # VCR: The Sales Account needs to be created manually in Fortnox
    context 'when saving a Customer with a Sales Account set' do
      let(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_sales_account") do
          repository.save(
            described_class::MODEL.new(
              name: 'Customer with Sales Account',
              sales_account: '3001'
            )
          )
        end
      end

      context 'when fetching that Customer' do
        subject { fetched_customer.sales_account }

        let(:fetched_customer) do
          VCR.use_cassette("#{vcr_dir}/find_with_sales_account") do
            repository.find(customer.customer_number)
          end
        end

        it { is_expected.to eq('3001') }
      end
    end
  end
end
