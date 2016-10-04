module Matchers
  module Model
    class EnumMatcher < TypeMatcher
      def initialize( attribute, valid_hash, attr_type, enum_type, enum_types, nonsense_value: 'NONSENSE'.freeze )
        valid_value = Fortnox::API::Types.const_get(enum_types).values.first

        super( attribute, valid_hash, attr_type, valid_value, nonsense_value )

        @enum_type = Fortnox::API::Types.const_get(enum_type)
        @expected_error = "Exception missing for nonsense value #{@invalid_value.inspect}"
      end

      private

        def expected_type?
          @actual_type = @klass.schema[@attribute]
          @actual_type == @enum_type
        end
    end
  end
end
