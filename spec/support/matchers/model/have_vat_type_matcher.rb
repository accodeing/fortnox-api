module Matchers
  module Model
    def have_vat_type( attribute, valid_hash = {} )
      HaveVatTypeMatcher.new( attribute, valid_hash )
    end

    class HaveVatTypeMatcher < EnumMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'vat type', 'VATType', 'VATTypes' )
      end
    end
  end
end
