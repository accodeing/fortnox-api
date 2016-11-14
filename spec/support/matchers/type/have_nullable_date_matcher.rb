module Matchers
  module Type
    def have_nullable_date( attribute, valid_value, invalid_value )
      HaveNullableDateMatcher.new( attribute, valid_value, invalid_value )
    end

    class HaveNullableDateMatcher < HaveNullableMatcher
      def initialize( attribute, valid_value, invalid_value )
        @attribute = attribute
        @valid_value = valid_value
        @invalid_value = invalid_value
        @expected_error = ArgumentError
        @expected_error_message = 'invalid date'
        @failure_description = ''
      end

      def matches?( klass )
        @klass = klass

        accepts_nil? && accepts_valid_value? && rejects_invalid_value?
      end

      def description
        "have nullable attribute #{ @attribute.inspect }"
      end

      def failure_message
        "Expected class to have nullable attribute #{ @attribute.inspect }" << @failure_description
      end

      private

        def accepts_nil?
          @klass.new(@attribute => nil)
        end

        def accepts_valid_value?
          model = @klass.new(@attribute => @valid_value)
          model.send(@attribute) == @valid_value
        end

        def rejects_invalid_value?
          @klass.new(@attribute => @invalid_value)

          @failure_description << " (Expected #{ @expected_error }, but got none)"
          return false
        rescue @expected_error => error
          if error.message == @expected_error_message
            return true
          else
            fail_message = "Expected error message to include #{ expected_message.inspect }, "\
                           "but was #{ error.message.inspect }"
            fail(fail_message)
          end
        end
    end
  end
end
