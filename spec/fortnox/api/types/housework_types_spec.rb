# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/types'
require 'fortnox/api/repositories/order'
require 'fortnox/api/models/order'
require 'fortnox/api/types/order_row'

# rubocop:disable RSpec/DescribeClass
describe 'HouseworkTypes', integration: true do
  include Helpers::Configuration

  before { set_api_test_configuration }

  let(:repository) { Fortnox::API::Repository::Order.new }

  shared_examples_for 'housework type' do |type, tax_reduction_type, legacy: false, housework: true|
    subject do
      cassette = "orders/housework_type_#{type.downcase}"
      -> { VCR.use_cassette(cassette) { repository.save(document) } }
    end

    let(:document) do
      Fortnox::API::Model::Order.new(
        customer_number: '1',
        tax_reduction_type: tax_reduction_type,
        order_rows: [
          Fortnox::API::Types::OrderRow.new(
            ordered_quantity: 1,
            article_number: '0000',
            housework_type: Fortnox::API::Types::HouseworkTypes[type],
            housework: housework
          )
        ]
      )
    end

    context "when creating an OrderRow with housework_type set to #{type}" do
      if legacy
        let(:error_message) { 'Skattereduktion för den valda typen av husarbete har upphört.' }

        it 'raises an error' do
          is_expected.to raise_error(Fortnox::API::RemoteServerError, error_message)
        end
      else
        it { is_expected.not_to raise_error }
      end
    end
  end

  TYPE_ROT = Fortnox::API::Types::TaxReductionTypes['rot']
  TYPE_RUT = Fortnox::API::Types::TaxReductionTypes['rut']

  it_behaves_like 'housework type', 'CONSTRUCTION', TYPE_ROT
  it_behaves_like 'housework type', 'ELECTRICITY', TYPE_ROT
  it_behaves_like 'housework type', 'GLASSMETALWORK', TYPE_ROT
  it_behaves_like 'housework type', 'GROUNDDRAINAGEWORK', TYPE_ROT
  it_behaves_like 'housework type', 'MASONRY', TYPE_ROT
  it_behaves_like 'housework type', 'PAINTINGWALLPAPERING', TYPE_ROT
  it_behaves_like 'housework type', 'HVAC', TYPE_ROT
  it_behaves_like 'housework type', 'OTHERCOSTS', TYPE_ROT, housework: false

  it_behaves_like 'housework type', 'MAJORAPPLIANCEREPAIR', TYPE_RUT
  it_behaves_like 'housework type', 'MOVINGSERVICES', TYPE_RUT
  it_behaves_like 'housework type', 'ITSERVICES', TYPE_RUT
  it_behaves_like 'housework type', 'CLEANING', TYPE_RUT
  it_behaves_like 'housework type', 'TEXTILECLOTHING', TYPE_RUT
  it_behaves_like 'housework type', 'SNOWPLOWING', TYPE_RUT
  it_behaves_like 'housework type', 'GARDENING', TYPE_RUT
  it_behaves_like 'housework type', 'BABYSITTING', TYPE_RUT
  it_behaves_like 'housework type', 'OTHERCARE', TYPE_RUT
  it_behaves_like 'housework type', 'OTHERCOSTS', TYPE_RUT, housework: false

  # rubocop:disable RSpec/RepeatedDescription
  pending 'to be added' do
    raise Exception, 'Will be supported 2021-01-01'
    # it_behaves_like 'housework type', 'HOMEMAINTENANCE', TYPE_RUT
    # it_behaves_like 'housework type', 'FURNISHING', TYPE_RUT
    # it_behaves_like 'housework type', 'TRANSPORTATIONSERVICES', TYPE_RUT
    # it_behaves_like 'housework type', 'WASHINGANDCAREOFCLOTHING', TYPE_RUT
  end

  pending 'to be added' do
    raise Exception, 'Will be supported 2021-01-01'
    # it_behaves_like 'housework type', 'SOLARCELLS', TYPE_GREEN
    # it_behaves_like 'housework type', 'STORAGESELFPRODUCEDELECTRICTY', TYPE_GREEN
    # it_behaves_like 'housework type', 'CHARGINGSTATIONELECTRICVEHICLE', TYPE_GREEN
    # it_behaves_like 'housework type', 'OTHERCOSTS', TYPE_GREEN
  end
  # rubocop:enable RSpec/RepeatedDescription

  it_behaves_like 'housework type', 'COOKING', TYPE_RUT, legacy: true
  it_behaves_like 'housework type', 'TUTORING', TYPE_RUT, legacy: true

  describe 'without tax reduction type' do
    subject do
      cassette = 'orders/housework_without_tax_reduction_type'
      -> { VCR.use_cassette(cassette) { repository.save(document) } }
    end

    let(:document) do
      Fortnox::API::Model::Order.new(
        customer_number: '1',
        order_rows: [
          Fortnox::API::Types::OrderRow.new(
            ordered_quantity: 1,
            article_number: '0000',
            housework_type: Fortnox::API::Types::HouseworkTypes['CONSTRUCTION'],
            housework: true
          )
        ]
      )
    end

    let(:error_message) do
      'Dokument utan angiven skattereduktionstyp får inte innehålla artikelrader med husarbetestyp.'
    end

    it 'raises an error' do
      is_expected.to raise_error(Fortnox::API::RemoteServerError, error_message)
    end
  end

  describe 'with OTHERCOSTS' do
    subject do
      cassette = 'orders/housework_othercoses_invalid'
      -> { VCR.use_cassette(cassette) { repository.save(document) } }
    end

    let(:document) do
      Fortnox::API::Model::Order.new(
        customer_number: '1',
        tax_reduction_type: TYPE_ROT,
        order_rows: [
          Fortnox::API::Types::OrderRow.new(
            ordered_quantity: 1,
            article_number: '0000',
            housework_type: Fortnox::API::Types::HouseworkTypes['OTHERCOSTS'],
            housework: true
          )
        ]
      )
    end

    let(:error_message) { 'Kan inte sätta typen övrig kostnad på en rad markerad som husarbete.' }

    it "can't have housework set to true" do
      is_expected.to raise_error(Fortnox::API::RemoteServerError, error_message)
    end
  end

  describe 'with wrong tax reduction type' do
    subject do
      cassette = 'orders/housework_invalid_tax_reduction_type'
      -> { VCR.use_cassette(cassette) { repository.save(document) } }
    end

    let(:type) { 'CONSTRUCTION' }
    let(:tax_reduction_type) { TYPE_RUT }
    let(:document) do
      Fortnox::API::Model::Order.new(
        customer_number: '1',
        tax_reduction_type: tax_reduction_type,
        order_rows: [
          Fortnox::API::Types::OrderRow.new(
            ordered_quantity: 1,
            article_number: '0000',
            housework_type: Fortnox::API::Types::HouseworkTypes[type],
            housework: true
          )
        ]
      )
    end

    let(:error_message) do
      "Dokument med skattereduktionstypen '#{tax_reduction_type}' " \
      "får inte innehålla rader med husarbetestypen '#{type}'."
    end

    it 'raises an error' do
      is_expected.to raise_error(Fortnox::API::RemoteServerError, error_message)
    end
  end
end
# rubocop:enable RSpec/DescribeClass
