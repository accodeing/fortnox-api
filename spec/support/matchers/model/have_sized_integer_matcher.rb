module Matchers
  module Model
    def have_sized_integer( attribute, min_value, max_value, valid_hash = {} )
      options = { min_value: min_value, max_value: max_value, step: 1 }
      NumericMatcher.new( attribute, valid_hash, 'sized integer', options )
    end
  end
end
