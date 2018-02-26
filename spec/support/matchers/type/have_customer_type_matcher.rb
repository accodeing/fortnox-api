# frozen_string_literal: true

module Matchers
  module Type
    def have_customer_type(attribute, valid_hash = {})
      HaveCustomerTypeMatcher.new(attribute, valid_hash)
    end

    class HaveCustomerTypeMatcher < EnumMatcher
      def initialize(attribute, valid_hash)
        super(attribute, valid_hash, 'CustomerType', 'CustomerTypes')
      end
    end
  end
end
