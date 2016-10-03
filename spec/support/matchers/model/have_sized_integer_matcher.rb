module Matchers
  module Model
    def have_sized_integer( attribute, min_value, max_value, valid_hash )
      HaveSizedIntegerMatcher.new( attribute, min_value, max_value, valid_hash )
    end

    class HaveSizedIntegerMatcher < NumericMatcher
      def initialize( attribute, min_value, max_value, valid_hash )
        @step = 1

        super( attribute, min_value, max_value, valid_hash, 'sized integer' )
      end
    end
  end
end
