module Matchers
  module Model
    def have_discount_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'DiscountType', 'DiscountTypes' )
    end
  end
end
