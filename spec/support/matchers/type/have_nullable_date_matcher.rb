module Matchers
  module Type
    def have_nullable_date( attribute, valid_value, invalid_value )
      HaveNullableDateMatcher.new( attribute, valid_value, invalid_value )
    end

    class HaveNullableDateMatcher < HaveNullableMatcher
      def initialize( attribute, valid_value, invalid_value )
        @expected_error = ArgumentError
        @expected_error_message = 'invalid date'

        super( attribute, valid_value, invalid_value )
      end
    end
  end
end
