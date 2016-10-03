module Matchers
  module Model
    def have_customer_type( attribute, valid_hash = {} )
      HaveCustomerTypeMatcher.new( attribute, valid_hash )
    end

    class HaveCustomerTypeMatcher < EnumMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'customer type', 'CustomerType', 'CustomerTypes' )
      end
    end
  end
end
