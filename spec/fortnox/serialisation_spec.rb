# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Serialisation do
  # JSON renders anything it doesn't recognise through to_s, so the thing
  # actually being guarded here is that no "#<Fortnox::Structs::…>" string
  # ever reaches a payload.
  describe 'Resource#to_json' do
    subject(:json) { JSON.parse(order.to_json) }

    let(:order) do
      Fortnox::Order.stub(
        customer_number: '1',
        order_rows: [{ article_number: '101', delivered_quantity: 2 }]
      )
    end

    it 'renders nested struct rows as objects' do
      expect(json['order_rows']).to eq([{ 'article_number' => '101', 'delivered_quantity' => 2.0 }])
    end

    it 'uses model attribute names rather than the Fortnox wire names' do
      expect(json).to include('customer_number' => '1')
    end

    it 'leaves the API representation to to_api' do
      expect(JSON.parse(order.to_api)).to have_key('Order')
    end

    it 'renders a struct-typed attribute that is not in an array' do
      customer = Fortnox::Customer.stub(name: 'Acme', default_delivery_types: { invoice: 'EMAIL' })

      expect(JSON.parse(customer.to_json)['default_delivery_types']).to include('invoice' => 'EMAIL')
    end
  end

  describe 'Struct#to_json' do
    it 'renders its attributes' do
      row = Fortnox::Structs::OrderRow.new(article_number: '101')

      expect(JSON.parse(row.to_json)).to eq('article_number' => '101')
    end
  end

  describe 'Collection#to_json' do
    subject(:json) { JSON.parse(collection.to_json) }

    let(:collection) do
      Fortnox::Collection.new(
        [Fortnox::Customer.stub(name: 'Acme'), Fortnox::Customer.stub(name: 'Other')],
        total: 2, pages: 1, current_page: 1
      )
    end

    it 'renders as an array of its records' do
      expect(json).to eq([{ 'name' => 'Acme' }, { 'name' => 'Other' }])
    end

    it 'keeps pagination metadata off the rendered payload but on the object', :aggregate_failures do
      expect(json).to be_an(Array)
      expect(collection.total).to eq(2)
    end
  end

  describe 'render options' do
    subject(:customer) { Fortnox::Customer.stub(name: 'Acme', city: 'Gothenburg') }

    # ActiveSupport's Hash#as_json slices a symbol-keyed hash, so a string
    # list would match nothing and silently render {}. Both spellings work.
    it 'applies :only given symbols' do
      expect(JSON.parse(customer.to_json(only: [:name]))).to eq('name' => 'Acme')
    end

    it 'applies :only given strings' do
      expect(JSON.parse(customer.to_json(only: ['name']))).to eq('name' => 'Acme')
    end

    it 'applies :except' do
      expect(JSON.parse(customer.to_json(except: ['city']))).to eq('name' => 'Acme')
    end

    it 'applies :only to every record of a collection' do
      collection = Fortnox::Collection.new([customer], total: 1)

      expect(JSON.parse(collection.to_json(only: ['name']))).to eq([{ 'name' => 'Acme' }])
    end

    # JSON.generate hands to_json a JSON::State, which is not a render option.
    it 'ignores a non-options argument when nested inside JSON.generate' do
      expect(JSON.parse(JSON.generate(customer: customer))['customer']).to include('name' => 'Acme')
    end
  end

  describe '.json_safe' do
    it 'walks nested arrays and hashes, stringifying keys at every level' do
      value = { rows: [Fortnox::Structs::OrderRow.new(article_number: '101')] }

      expect(described_class.json_safe(value)).to eq('rows' => [{ 'article_number' => '101' }])
    end

    it 'passes primitives through untouched' do
      expect(described_class.json_safe(['a', 1, 2.0, true, nil])).to eq(['a', 1, 2.0, true, nil])
    end
  end
end
