# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Housework types', order: :defined do # rubocop:disable RSpec/DescribeClass
  let(:vcr_dir) { 'orders' }

  shared_examples 'housework type' do |type, tax_reduction_type, legacy: false, housework: true|
    context "with housework_type #{type}" do
      let(:order) do
        Fortnox::Order.stub(
          customer_number: '1',
          tax_reduction_type: tax_reduction_type,
          order_rows: [
            Fortnox::Structs::OrderRow.new(
              ordered_quantity: 1,
              article_number: '101',
              housework_type: type,
              housework: housework
            )
          ]
        )
      end

      let(:cassette_name) { "housework_type_#{type.downcase}#{"_#{tax_reduction_type}" if type == 'OTHERCOSTS'}" }
      let(:save_order) do
        VCR.use_cassette("#{vcr_dir}/#{cassette_name}") do
          Fortnox::Order.save(order)
        end
      end

      if legacy
        it 'raises an error' do
          expect { save_order }.to raise_error(Fortnox::RequestError)
        end
      else
        it 'is accepted by the API' do
          expect { save_order }.not_to raise_error
        end
      end
    end
  end

  describe 'ROT types' do
    it_behaves_like 'housework type', 'CONSTRUCTION', 'rot'
    it_behaves_like 'housework type', 'ELECTRICITY', 'rot'
    it_behaves_like 'housework type', 'GLASSMETALWORK', 'rot'
    it_behaves_like 'housework type', 'GROUNDDRAINAGEWORK', 'rot'
    it_behaves_like 'housework type', 'MASONRY', 'rot'
    it_behaves_like 'housework type', 'PAINTINGWALLPAPERING', 'rot'
    it_behaves_like 'housework type', 'HVAC', 'rot'
    it_behaves_like 'housework type', 'OTHERCOSTS', 'rot', housework: false
  end

  describe 'RUT types' do
    it_behaves_like 'housework type', 'MAJORAPPLIANCEREPAIR', 'rut'
    it_behaves_like 'housework type', 'MOVINGSERVICES', 'rut'
    it_behaves_like 'housework type', 'ITSERVICES', 'rut'
    it_behaves_like 'housework type', 'CLEANING', 'rut'
    it_behaves_like 'housework type', 'TEXTILECLOTHING', 'rut'
    it_behaves_like 'housework type', 'SNOWPLOWING', 'rut'
    it_behaves_like 'housework type', 'GARDENING', 'rut'
    it_behaves_like 'housework type', 'BABYSITTING', 'rut'
    it_behaves_like 'housework type', 'OTHERCARE', 'rut'
    it_behaves_like 'housework type', 'OTHERCOSTS', 'rut', housework: false
  end

  describe 'legacy types' do
    it_behaves_like 'housework type', 'COOKING', 'rut', legacy: true
    it_behaves_like 'housework type', 'TUTORING', 'rut', legacy: true
  end

  describe 'OTHERCOSTS with housework set to true' do
    let(:order) do
      Fortnox::Order.stub(
        customer_number: '1',
        tax_reduction_type: 'rot',
        order_rows: [
          Fortnox::Structs::OrderRow.new(
            ordered_quantity: 1,
            article_number: '101',
            housework_type: 'OTHERCOSTS',
            housework: true
          )
        ]
      )
    end

    let(:save_order) do
      VCR.use_cassette("#{vcr_dir}/housework_othercosts_invalid") do
        Fortnox::Order.save(order)
      end
    end

    it 'raises an error' do
      expect { save_order }.to raise_error(Fortnox::RequestError)
    end
  end

  describe 'wrong tax reduction type' do
    let(:order) do
      Fortnox::Order.stub(
        customer_number: '1',
        tax_reduction_type: 'rut',
        order_rows: [
          Fortnox::Structs::OrderRow.new(
            ordered_quantity: 1,
            article_number: '101',
            housework_type: 'CONSTRUCTION',
            housework: true
          )
        ]
      )
    end

    let(:save_order) do
      VCR.use_cassette("#{vcr_dir}/housework_invalid_tax_reduction_type") do
        Fortnox::Order.save(order)
      end
    end

    it 'raises an error' do
      expect { save_order }.to raise_error(Fortnox::RequestError)
    end
  end
end
