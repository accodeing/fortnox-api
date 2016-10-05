module Matchers
  module Model
    def have_discount_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'discount type', 'DiscountType', 'DiscountTypes' )
    end
  end
end
