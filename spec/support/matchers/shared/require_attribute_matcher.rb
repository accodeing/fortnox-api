module Matchers
  module Shared
    class RequireAttributeMatcher
      def initialize( attribute )
        @attribute = attribute
      end

      def matches?( klass )
        @klass = klass

        raise_error && includes_error_message
      end

      def failure_message
        return no_exception_failure_message unless raise_error
        return wrong_error_message unless includes_error_message
      end

      def description
        "require attribute #{ @attribute.inspect }"
      end

      private

        def no_exception_failure_message
          "Expected class to raise #{ EXCEPTION } "\
          "when attribute #{ @attribute.inspect } is missing."
        end

        def wrong_error_message
          "Expected exception to equal #{ expected_error_message.inspect }. "\
          "Message was #{ @wrong_error_message.inspect }."
        end
    end
  end
end
