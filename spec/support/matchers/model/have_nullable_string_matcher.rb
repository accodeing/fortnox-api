module Matchers
  module Model
    def have_nullable_string( attribute, valid_hash = {} )
      HaveNullableStringMatcher.new( attribute, valid_hash )
    end

    class HaveNullableStringMatcher < AttributeMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'nullable string' )
      end

      def matches?( klass )
        super

        accepts_nil? && accepts_string? && rejects_non_string?
      end

      private

        def accepts_nil?
          model = @klass.new( @valid_hash.merge( @attribute => nil ) )
          model.send(@attribute).nil?
        end

        def accepts_string?
          valid_string = 'A string'
          model = @klass.new( @valid_hash.merge( @attribute => valid_string ) )
          model.send(@attribute) == 'A string'
        end

        def rejects_non_string?
          non_string = 10.0
          @klass.new( @valid_hash.merge( @attribute => non_string ) )
        rescue Dry::Struct::Error => error
          expected_message = "#{non_string.inspect} (#{non_string.class}) "\
                             "has invalid type for #{@attribute.inspect}"
          if error.message.include?(expected_message)
            return true
          else
            fail_message = "Expected error message to include #{expected_message.inspect}, "\
                           "but was #{error.message.inspect}"
            fail(fail_message)
          end

        end
    end

  end
end
