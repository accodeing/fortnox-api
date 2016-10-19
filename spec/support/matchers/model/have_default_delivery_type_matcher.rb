module Matchers
  module Model
    def have_default_delivery_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'DefaultDeliveryType', 'DefaultDeliveryTypes' )
    end
  end
end
