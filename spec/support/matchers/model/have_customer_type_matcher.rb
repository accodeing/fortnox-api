module Matchers
  module Model
    def have_customer_type( attribute, valid_hash )
      HaveCustomerTypeMatcher.new( attribute, valid_hash )
    end

    class HaveCustomerTypeMatcher < AttributeMatcher
      NONSENSE_VALUE = 'NONSENSE_VALUE'.freeze

      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'customer type' )
      end

      def matches?( klass )
        super

        correct_type? && rejects_invalid_value?
      end

      private

        def correct_type?
          actual_type = @klass.schema[@attribute]
          if actual_type == Fortnox::API::Types::CustomerType
            return true
          else
            @errors << "Attribute #{@attribute.inspect} was expected to be of type #{Fortnox::API::Types::CustomerType}, but was #{actual_type}"
            return false
          end
        end

        def rejects_invalid_value?
          expect_error("Exception missing for nonsense value #{NONSENSE_VALUE.inspect}") do
            @klass.new( @valid_hash.merge( @attribute => NONSENSE_VALUE ) )
          end
        end
    end
  end
end
