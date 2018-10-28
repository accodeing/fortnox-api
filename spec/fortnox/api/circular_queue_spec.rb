# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/circular_queue'

describe Fortnox::API::CircularQueue do
  describe 'start index' do
    context 'when running several times' do
      let(:items) { ['a', 'b', 'c'] }

      it 'does not start with the same item each time' do
        set = Set.new([described_class.new(*items).next,
                       described_class.new(*items).next,
                       described_class.new(*items).next,
                       described_class.new(*items).next])

        expect(set.size).to be > 1
      end
    end
  end

  describe '#next' do
    context 'when several items in queue' do
      let(:queue) { described_class.new(*['a', 'b', 'c']) }

      it 'circulates the items' do
        first_item = queue.next
        second_item = queue.next
        third_item = queue.next
        expect(first_item).to eq(queue.next)
        expect(first_item).not_to eq(second_item)
        expect(first_item).not_to eq(third_item)
      end
    end

    context 'when only one item in queue' do
      let(:queue) { described_class.new('a') }

      it 'circulates the item' do
        first_item = queue.next
        expect(first_item).to eq(queue.next)
      end
    end
  end
end
