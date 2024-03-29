# frozen_string_literal: true

module Matchers
  module Type
    class EnumMatcher < TypeMatcher
      def initialize(attribute, valid_hash, enum_type, enum_types, nonsense_value: 'NONSENSE')
        valid_value = Fortnox::API::Types.const_get(enum_types).values.first

        super(attribute, valid_hash, enum_type, valid_value, nonsense_value)

        @enum_type = Fortnox::API::Types.const_get(enum_type)
        @expected_error = "Exception missing for nonsense value #{@invalid_value.inspect}"
      end

      private

      def expected_type?
        @actual_type = @klass.schema.keys.find { |x| x.name == @attribute }&.type
        @actual_type == @enum_type
      end
    end
  end
end
