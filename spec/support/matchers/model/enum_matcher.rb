module Matchers
  module Model
    class EnumMatcher < AttributeMatcher
      def initialize( attribute, valid_hash, attr_type, enum_type, enum_types )
        super( attribute, valid_hash, attr_type )
        @enum_type = Fortnox::API::Types.const_get(enum_type)
        @enum_values = Fortnox::API::Types.const_get(enum_types).values
        @nonsense_value ||= 'NONSENSE_VALUE'.freeze
      end

      def matches?( klass )
        super

        correct_type? && rejects_invalid_value? && accepts_valid_value?
      end

      private

        def correct_type?
          actual_type = @klass.schema[@attribute]
          if actual_type == @enum_type
            return true
          else
            @errors << "Attribute #{@attribute.inspect} was expected to be of type #{@attribute_type}, but was #{actual_type}"
            return false
          end
        end

        def rejects_invalid_value?
          expected_message = "Exception missing for nonsense value #{@nonsense_value.inspect}"
          expect_error(expected_message) do
            @klass.new( @valid_hash.merge( @attribute => @nonsense_value ) )
          end
        end

        def accepts_valid_value?
          valid_value = @enum_values.first
          @klass.new( @valid_hash.merge( @attribute => valid_value ) )
        end
    end
  end
end
