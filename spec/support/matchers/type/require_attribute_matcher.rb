require 'fortnox/api'

module Matchers
  module Type
    def require_attribute( attribute, attr_type )
      RequireAttributeMatcher.new( attribute, attr_type )
    end

    class RequireAttributeMatcher
      def initialize( attribute, attr_type )
        @attribute = attribute
        @attr_type = attr_type
        @exception = Dry::Struct::Error
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

      def raise_error
        @klass.new({})

        false # Fail test since expected error is not thrown
      rescue @exception
        true
      end


      def includes_error_message
        @klass.new({})
      rescue @exception => error
        if error.message == expected_error_message
          return true
        else
          @wrong_error_message = error.message
          return false
        end
      end

      def expected_error_message
        "[#{ @klass }.new] #{ @attribute.inspect } is missing in Hash input"
      end

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
