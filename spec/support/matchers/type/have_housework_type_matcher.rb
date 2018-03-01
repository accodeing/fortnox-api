# frozen_string_literal: true

module Matchers
  module Type
    def have_housework_type(attribute, valid_hash = {})
      EnumMatcher.new(attribute, valid_hash, 'HouseworkType', 'HouseworkTypes')
    end
  end
end
