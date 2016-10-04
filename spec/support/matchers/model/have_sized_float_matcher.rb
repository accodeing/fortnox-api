module Matchers
  module Model
    def have_sized_float( attribute, min_value, max_value, valid_hash = {} )
      NumericMatcher.new( attribute, min_value, max_value, valid_hash, 'sized float', 0.1 )
    end
  end
end
