module Matchers
  module Model
    def have_vat_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'vat type', 'VATType', 'VATTypes' )
    end
  end
end
