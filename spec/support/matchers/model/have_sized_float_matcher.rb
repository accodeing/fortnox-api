module Matchers
  module Model
    def have_sized_float( attribute, min_value, max_value, valid_hash )
      HaveSizedFloatMatcher.new( attribute, min_value, max_value, valid_hash )
    end

    class HaveSizedFloatMatcher < NumericMatcher
      def initialize( attribute, min_value, max_value, valid_hash )
        @step = 0.1

        super( attribute, min_value, max_value, valid_hash, 'sized float' )
      end
    end
  end
end
