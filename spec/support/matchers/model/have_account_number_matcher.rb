module Matchers
  module Model
    def have_account_number( attribute, valid_hash = {} )
      HaveAccountNumberMatcher.new( attribute, valid_hash )
    end

    class HaveAccountNumberMatcher < AttributeMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'account number' )
      end

      def matches?( klass )
        super

        correct_type? && rejects_invalid_value? && accepts_valid_value?
      end

      private

        def correct_type?
          actual_type = @klass.schema[@attribute]
          if actual_type == Fortnox::API::Types::AccountNumber
            return true
          else
            @errors << "Attribute #{@attribute.inspect} was expected to be of type #{@attribute_type}, but was #{actual_type}"
            return false
          end
        end

        def rejects_invalid_value?
          invalid_value = -1
          expect_error("Exception missing for invalid value #{invalid_value.inspect}") do
            @klass.new( @valid_hash.merge( @attribute => invalid_value ) )
          end
        end

        def accepts_valid_value?
          @klass.new( @valid_hash.merge( @attribute => 1000 ) )
        end
    end
  end
end
