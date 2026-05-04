# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Collection do
  let(:items) { [Object.new, Object.new] }

  describe '#each' do
    it 'iterates the wrapped items' do
      collection = described_class.new(items)
      expect(collection.each.to_a).to eq(items)
    end
  end

  describe 'pagination accessors' do
    it 'exposes total, pages, and current_page', :aggregate_failures do
      collection = described_class.new(items, total: 100, pages: 5, current_page: 2)
      expect(collection.total).to eq(100)
      expect(collection.pages).to eq(5)
      expect(collection.current_page).to eq(2)
    end

    it 'returns nil when no pagination metadata was provided', :aggregate_failures do
      collection = described_class.new(items)
      expect(collection.total).to be_nil
      expect(collection.pages).to be_nil
      expect(collection.current_page).to be_nil
    end

    it 'preserves pagination metadata even when the collection is empty' do
      collection = described_class.new([], total: 0, pages: 0, current_page: 1)
      expect(collection.current_page).to eq(1)
    end
  end

  describe 'array-like delegation' do
    let(:collection) { described_class.new(items) }

    it 'delegates first, last, size, and []', :aggregate_failures do
      expect(collection.first).to eq(items.first)
      expect(collection.last).to eq(items.last)
      expect(collection.size).to eq(2)
      expect(collection[0]).to eq(items.first)
    end

    it 'is empty? when wrapping an empty array' do
      expect(described_class.new([])).to be_empty
    end
  end

  describe 'Enumerable' do
    it 'maps via Enumerable' do
      collection = described_class.new([1, 2, 3])
      expect(collection.map { |i| i * 2 }).to eq([2, 4, 6])
    end
  end
end
