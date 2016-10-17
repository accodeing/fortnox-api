module Matchers
  module Model
    def have_default_delivery_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute,
                      valid_hash,
                      'default delivery type',
                      'DefaultDeliveryType',
                      'DefaultDeliveryTypes' )
    end
  end
end
