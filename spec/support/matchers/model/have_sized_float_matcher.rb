module Matchers
  module Model
    def have_sized_float( attribute, min_value, max_value, valid_hash )
      HaveSizedFloatMatcher.new( attribute, min_value, max_value, valid_hash )
    end

    class HaveSizedFloatMatcher < AttributeMatcher
      STEP = 0.1

      def initialize( attribute, min_value, max_value, valid_hash )
        super( attribute, valid_hash, 'sized float' )

        @min_value = min_value
        @max_value = max_value
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
    end
  end
end
