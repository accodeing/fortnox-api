module Matchers
  module Model
    class NumericMatcher < AttributeMatcher
      def initialize( attribute, valid_hash, attr_type, options )
        super( attribute, valid_hash, attr_type )

        @min_value = options[:min_value]
        @max_value = options[:max_value]
        @step = options[:step]
      end

      def matches?( klass )
        super

        rejects_too_small_value? &&
          accepts_min_value? &&
          accepts_max_value? &&
          rejects_too_big_value?
      end

      private

        def rejects_too_small_value?
          too_small_value = @min_value - @step
          expected_error_message = "Exception missing for too small value (#{ too_small_value })"
          rejects_value?(too_small_value, expected_error_message)
        end

        def accepts_min_value?
          @klass.new( @valid_hash.merge( @attribute => @min_value ) )
        end

        def accepts_max_value?
          @klass.new( @valid_hash.merge( @attribute => @max_value ) )
        end

        def rejects_too_big_value?
          too_big_value = @max_value + @step
          expected_error_message = "Exception missing for too big value (#{ too_big_value })"
          rejects_value?(too_big_value, expected_error_message)
        end

        def rejects_value?(value, expected_error_message)
          expect_error(expected_error_message) do
            @klass.new( @valid_hash.merge( @attribute => value ) )
          end
        end
    end
  end
end
