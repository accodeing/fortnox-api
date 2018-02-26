# frozen_string_literal: true

module Matchers
  module Type
    def have_vat_type(attribute, valid_hash = {})
      EnumMatcher.new(attribute, valid_hash, 'VATType', 'VATTypes')
    end
  end
end
