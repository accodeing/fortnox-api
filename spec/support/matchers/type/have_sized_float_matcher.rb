module Matchers
  module Type
    def have_sized_float( attribute, min_value, max_value, valid_hash = {} )
      options = { min_value: min_value, max_value: max_value, step: 0.1 }
      NumericMatcher.new( attribute, valid_hash, 'sized float', options )
    end
  end
end
