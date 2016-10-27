require 'fortnox/api'

module Matchers
  module Type
    def require_attribute(attribute, valid_hash = {})
      RequireAttributeMatcher.new(attribute, valid_hash)
    end

    class RequireAttributeMatcher
      EXCEPTION = Fortnox::API::MissingAttributeError

      def initialize( attribute, valid_hash )
        @attribute = attribute
        @invalid_hash = valid_hash.dup.tap{ |hash| hash.delete( attribute ) }
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
          @klass.new(@invalid_hash)

          false # Fail test since expected error is not thrown

        rescue EXCEPTION
          true
        end

        def includes_error_message
          @klass.new(@invalid_hash)
        rescue EXCEPTION => error
          if error.message.include? expected_error_message
            return true
          else
            @wrong_error_message = error.message
            return false
          end
        end

        def expected_error_message
          @attribute.to_s
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
