# frozen_string_literal: true

module Matchers
  module Type
    def have_sized_string(attribute, max_size, valid_hash = {})
      HaveSizedStringMatcher.new(attribute, max_size, valid_hash)
    end

    class HaveSizedStringMatcher < AttributeMatcher
      def initialize(attribute, max_size, valid_hash)
        super(attribute, valid_hash, 'sized string')
        @max_size = max_size
      end

      def matches?(klass)
        @klass = klass

        accepts_max_size? && rejects_too_long_string?
      end

      private

      def accepts_max_size?
        @klass.new(@valid_hash.merge(@attribute => 'a' * @max_size))
      end

      def rejects_too_long_string?
        too_long = @max_size + 1
        too_long_string = 'a' * too_long
        expect_error("Exception missing for too long string (#{too_long} characters)") do
          @klass.new(@valid_hash.merge(@attribute => too_long_string))
        end
      end
    end
  end
end
