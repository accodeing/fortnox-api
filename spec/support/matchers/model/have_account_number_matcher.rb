module Matchers
  module Model
    def have_account_number( attribute, valid_hash = {} )
      HaveAccountNumberMatcher.new( attribute, valid_hash )
    end

    class HaveAccountNumberMatcher < TypeMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'account number', 1000, -1 )
        @expected_error = "Exception missing for invalid value #{ @invalid_value.inspect }".freeze
      end

      private

        def expected_type?
          @actual_type = @klass.schema[@attribute]
          @actual_type == Fortnox::API::Types::AccountNumber
        end
    end
  end
end
