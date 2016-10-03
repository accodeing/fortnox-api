module Matchers
  module Model
    def have_discount_type( attribute, valid_hash )
      HaveDiscountTypeMatcher.new( attribute, valid_hash )
    end

    class HaveDiscountTypeMatcher < EnumMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'discount type', 'DiscountType', 'DiscountTypes' )
      end
    end
  end
end
