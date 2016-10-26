module Matchers
  module Type
    def have_default_delivery_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'DefaultDeliveryType', 'DefaultDeliveryTypeValues' )
    end
  end
end
