# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::AttributeKeys do
  describe 'unknown attributes on a resource' do
    it 'raises on stub' do
      expect { Fortnox::Customer.stub(nmae: 'Acme') }
        .to raise_error(Fortnox::UnknownAttributeError, /:nmae/)
    end

    it 'raises on new' do
      expect { Fortnox::Customer.new(nmae: 'Acme') }
        .to raise_error(Fortnox::UnknownAttributeError)
    end

    it 'raises on update' do
      customer = Fortnox::Customer.stub(name: 'Acme')

      expect { customer.update(nmae: 'Other') }.to raise_error(Fortnox::UnknownAttributeError)
    end

    it 'names the resource and every unknown attribute', :aggregate_failures do
      Fortnox::Customer.stub(name: 'Acme', nmae: 'x', citty: 'y')
    rescue Fortnox::UnknownAttributeError => e
      expect(e.attribute_names).to eq([:nmae, :citty])
      expect(e.attribute_name).to eq(:nmae)
      expect(e.message).to include('Fortnox::Customer')
    end

    it 'is caught by a rescue on the shared attribute-error superclass' do
      expect { Fortnox::Customer.stub(nmae: 'Acme') }.to raise_error(Fortnox::AttributeError)
    end

    it 'still accepts read-only attributes, which round-trip through update' do
      expect(Fortnox::Customer.stub(name: 'Acme', url: 'https://example.com').name).to eq('Acme')
    end
  end

  describe 'unknown attributes on a struct' do
    it 'raises when constructed directly' do
      expect { Fortnox::Structs::OrderRow.new(artcile_number: '101') }
        .to raise_error(Fortnox::UnknownAttributeError, /Fortnox::Structs::OrderRow/)
    end

    it 'raises for a nested row passed to a resource' do
      expect { Fortnox::Order.stub(customer_number: '1', order_rows: [{ artcile_number: '101' }]) }
        .to raise_error(Fortnox::UnknownAttributeError)
    end
  end

  describe 'string keys' do
    it 'are accepted on a resource rather than reported as unknown' do
      expect(Fortnox::Customer.stub('name' => 'Acme').name).to eq('Acme')
    end

    it 'are accepted on update' do
      expect(Fortnox::Customer.stub(name: 'Acme').update('name' => 'Other').name).to eq('Other')
    end

    it 'are accepted on a struct' do
      expect(Fortnox::Structs::OrderRow.new('article_number' => '101').article_number).to eq('101')
    end

    # The failure this replaces: string-keyed rows produced "OrderRows":[{}]
    # and Fortnox created the order with empty rows.
    it 'carry through a nested row into the payload' do
      order = Fortnox::Order.stub(customer_number: '1', order_rows: [{ 'article_number' => '101' }])

      expect(order.serialise['Order']['OrderRows']).to eq([{ 'ArticleNumber' => '101' }])
    end

    it 'are accepted on a struct-typed attribute' do
      customer = Fortnox::Customer.stub(name: 'Acme', default_delivery_types: { 'invoice' => 'EMAIL' })

      expect(customer.default_delivery_types.invoice).to eq('EMAIL')
    end
  end

  describe 'parsing an API response' do
    subject(:order) { Fortnox::Order.parse(body) }

    # Fortnox adds fields over time. Strictness applies to what a caller
    # passes, never to what the API returns.
    let(:body) do
      {
        'Order' => {
          'CustomerNumber' => '1',
          'SomeBrandNewFortnoxField' => 'surprise',
          'OrderRows' => [{ 'ArticleNumber' => '101', 'AnotherNewField' => 42 }]
        }
      }
    end

    it 'tolerates an undeclared field on the resource' do
      expect(order.customer_number).to eq('1')
    end

    it 'tolerates an undeclared field on a nested struct', :aggregate_failures do
      expect(order.order_rows.first.article_number).to eq('101')
      expect(order.order_rows.first.to_h).not_to have_key(:another_new_field)
    end
  end

  describe '.normalise' do
    it 'leaves keys that cannot be symbolised alone' do
      expect(described_class.normalise(1 => 'a')).to eq(1 => 'a')
    end
  end
end
