# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/circular_queue'

RSpec.describe Fortnox::API::CircularQueue do
  let(:circular_queue) { described_class.new(*items) }
  let(:items) { [rand, rand] }

  context 'when there are items to iterate' do
    it 'increments the @@next_index' do
      circular_queue.class.class_variable_set(:@@next_index, 0)

      expect do
        circular_queue.next
      end.to change { circular_queue.class.class_variable_get(:@@next_index) }.to(1)
    end
  end

  context 'when the end of the queue is reached' do
    it 'resets the @@next_index' do
      circular_queue.class.class_variable_set(:@@next_index, items.size - 1)

      expect do
        circular_queue.next
      end.to change { circular_queue.class.class_variable_get(:@@next_index) }.to(0)
    end
  end

  it 'returns the current value' do
    index = circular_queue.class.class_variable_get(:@@next_index)

    expect(circular_queue.next).to eq(items[index])
  end
end
