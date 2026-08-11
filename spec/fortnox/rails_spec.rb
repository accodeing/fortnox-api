# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/rails'

RSpec.describe Fortnox::RailsSerialisation do
  let(:order) do
    Fortnox::Order.stub(
      customer_number: '1',
      order_rows: [{ article_number: '101', delivered_quantity: 2 }]
    )
  end

  let(:collection) do
    Fortnox::Collection.new([Fortnox::Customer.stub(name: 'Acme')], total: 1, pages: 1, current_page: 1)
  end

  describe 'Resource#as_json' do
    it 'renders the model attributes' do
      expect(order.as_json).to include('customer_number' => '1')
    end

    it 'renders nested struct rows as objects' do
      expect(order.as_json['order_rows']).to eq([{ 'article_number' => '101', 'delivered_quantity' => 2.0 }])
    end

    it 'agrees with to_json' do
      expect(order.as_json.to_json).to eq(order.to_json)
    end

    # The reason this file exists: ActiveSupport walks nested structures with
    # as_json, and Object#as_json would serialise the gem's instance variables.
    it 'keeps gem internals out of a nested render', :aggregate_failures do
      rendered = { orders: [order] }.to_json

      expect(rendered).not_to include('api_data', 'model_attributes', 'changes')
      expect(JSON.parse(rendered)['orders'].first).to include('customer_number' => '1')
    end
  end

  describe 'render options' do
    subject(:customer) { Fortnox::Customer.stub(name: 'Acme', city: 'Gothenburg') }

    it 'applies :only given symbols' do
      expect(customer.as_json(only: [:name])).to eq('name' => 'Acme')
    end

    it 'applies :only given strings' do
      expect(customer.as_json(only: ['name'])).to eq('name' => 'Acme')
    end

    it 'applies :except' do
      expect(customer.as_json(except: [:city])).to eq('name' => 'Acme')
    end

    it 'agrees with to_json for the same options' do
      expect(customer.as_json(only: ['name']).to_json).to eq(customer.to_json(only: [:name]))
    end

    # ActiveSupport hands an Array's options to each element, so options set
    # on a collection render reach the individual resources. (A Hash applies
    # :only to its own keys instead — that is ActiveSupport's rule, not ours.)
    it 'applies options to each resource of an array' do
      expect([customer].as_json(only: ['name'])).to eq([{ 'name' => 'Acme' }])
    end
  end

  describe 'Struct#as_json' do
    it 'renders its attributes' do
      expect(Fortnox::Structs::OrderRow.new(article_number: '101').as_json).to eq('article_number' => '101')
    end
  end

  describe 'Collection#as_json' do
    it 'renders as an array of its records' do
      expect(collection.as_json).to eq([{ 'name' => 'Acme' }])
    end

    it 'renders as an array when nested in another structure' do
      expect(JSON.parse({ customers: collection }.to_json)).to eq('customers' => [{ 'name' => 'Acme' }])
    end

    it 'agrees with to_json' do
      expect(collection.as_json.to_json).to eq(collection.to_json)
    end
  end

  it 'is not a runtime dependency of the gem' do
    runtime = Gem::Specification.load(File.expand_path('../../fortnox.gemspec', __dir__)).dependencies
                                .select { |dependency| dependency.type == :runtime }.map(&:name)

    expect(runtime).not_to include('activesupport')
  end
end
