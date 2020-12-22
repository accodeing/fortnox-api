# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/circular_queue'

describe Fortnox::API::CircularQueue do
  describe 'start index' do
    context 'when running several times' do
      subject { Set.new(samples).size }

      let(:test_array) { (0..99).to_a }
      let(:samples) { Array.new(100) { described_class.new(*test_array).next } }

      # NOTE: This test is not perfect. We are testing that a random generator
      # with 100 items to choose from does not choose the same item 100 times in a row.
      # Yes, the possibility is low, but I thought I should just mention it :)
      it 'does not start with the same item each time' do
        is_expected.to be > 1
      end
    end
  end

  describe '#next' do
    context 'when several items in queue' do
      let(:queue) { described_class.new(1, 2, 3) }
      let(:first_round) { Array.new(3) { queue.next } }
      let(:second_round) { Array.new(3) { queue.next } }

      it 'circulates the items' do
        first_round
        expect(first_round[0]).to eq(queue.next)
      end

      it 'circulates the items in the same order each time' do
        expect(first_round).to eq(second_round)
      end

      it 'circulates through given input' do
        expect(first_round.sort).to eq([1, 2, 3])
      end
    end

    context 'when only one item in queue' do
      let(:queue) { described_class.new(1) }

      it 'circulates the item' do
        first_item = queue.next
        expect(first_item).to eq(queue.next)
      end
    end
  end
end
