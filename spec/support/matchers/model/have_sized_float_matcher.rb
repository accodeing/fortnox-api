module Matchers
  module Model
    def have_sized_float( attribute, min_value, max_value, valid_hash )
      HaveSizedFloatMatcher.new( attribute, min_value, max_value, valid_hash )
    end

    class HaveSizedFloatMatcher
      STEP = 0.1

      def initialize( attribute, min_value, max_value, valid_hash )
        @attribute = attribute
        @min_value = min_value
        @max_value = max_value
        @valid_hash = valid_hash.dup
        @errors = ''
      end

      def matches?( klass )
        @klass = klass

        rejects_too_small_value? &&
          accepts_min_value? &&
          accepts_max_value? &&
          rejects_too_big_value?
      end

      def failure_message
        "Expected class to have attribute #{@attribute.inspect} defined as sized float, "\
        "but got following errors: 
        #{@errors}"
      end

      def description
        "have sized float attribute #{@attribute.inspect}"
      end

      private

        def rejects_too_small_value?
          too_small_value = @min_value - STEP
          expect_error("Exception missing for too small value (#{too_small_value})") do
            @klass.new( @valid_hash.merge( @attribute => too_small_value ) )
          end
        end

        def accepts_min_value?
          @klass.new( @valid_hash.merge( @attribute => @min_value ) )
        end

        def accepts_max_value?
          @klass.new( @valid_hash.merge( @attribute => @max_value ) )
        end

        def rejects_too_big_value?
          too_big_value = @max_value + STEP
          expect_error("Exception missing for too big value (#{too_big_value})") do
            @klass.new( @valid_hash.merge( @attriute => too_big_value ) )
          end
        end

        def expect_error(msg, &block)
          block.call

          @errors << msg
          false # Fail test since expected error not thrown
        rescue Dry::StructError
          # TODO: check if error message is correct
          true
        end
    end
  end
end
