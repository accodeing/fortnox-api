module Matchers
  module Model
    class TypeMatcher < AttributeMatcher
      def initialize( attr, valid_hash, attr_name, valid_value, invalid_value )
        super( attr, valid_hash, attr_name )

        @valid_value = valid_value
        @invalid_value = invalid_value
      end

      def matches?( klass )
        super

        correct_type? && rejects_invalid_value? && accepts_valid_value?
      end

      private

        def correct_type?
          return true if expected_type?

          @errors << "Attribute #{ @attribute.inspect } was expected to be of type #{ @attribute_type }, but was #{ @actual_type }"
          return false
        end

        def accepts_valid_value?
          @klass.new( @valid_hash.merge( @attribute => @valid_value ) )
        end

        def rejects_invalid_value?
          expect_error(@expected_error) do
            @klass.new( @valid_hash.merge( @attribute => @invalid_value ) )
          end
        end

    end
  end
end
