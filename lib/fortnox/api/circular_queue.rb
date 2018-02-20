# frozen_string_literal: true

require 'forwardable'

module Fortnox
  module API
    class CircularQueue
      extend Forwardable

      def initialize(*items)
        @queue = [*items]
        @@next_index = random_start_index
      end

      # support some general Array methods that fit Queues well
      def_delegators :@queue, :new, :[], :size

      def next
        value = @queue[@@next_index]
        if @@next_index == size - 1
          @@next_index = 0
        else
          @@next_index += 1
        end
        value
      end

      private

      def random_start_index
        Random.rand(@queue.size)
      end
    end
  end
end
