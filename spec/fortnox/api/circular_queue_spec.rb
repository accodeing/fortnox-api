# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/circular_queue'

describe Fortnox::API::CircularQueue do
  describe 'start index' do
    context 'when running several times' do
      let(:samples) { Array.new(100) { described_class.new(*(0..99)).next } }

      subject { Set.new(samples).size }

      # NOTE: This test is not perfect. We are testing that a random generator
      # with 100 items to choose from does not choose the same item 100 times in a row.
      # Yes, the possibility is low, I thought I should just mention it :)
      it 'does not start with the same item each time' do
        is_expected.to be > 1
      end
    end
  end

  describe '#next' do
    context 'when several items in queue' do
      let(:queue) { described_class.new(*['a', 'b', 'c']) }

      let(:first_round) { Array.new(3) { queue.next } }

      let(:second_round) { Array.new(3) { queue.next } }

      it 'circulates the items' do
        first_item = queue.next
        second_item = queue.next
        third_item = queue.next
        expect(first_item).to eq(queue.next)
        expect(first_item).not_to eq(second_item)
        expect(first_item).not_to eq(third_item)
      end

      it 'circulates the items in the same order each time' do
        expect(first_round).to eq(second_round)
      end

      it 'circulates through given input' do
        expect(first_round.sort).to eq(['a', 'b', 'c'])
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
