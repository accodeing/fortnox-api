module Matchers
  module Model
    def have_sized_integer( attribute, min_value, max_value, valid_hash = {} )
      NumericMatcher.new( attribute, min_value, max_value, valid_hash, 'sized integer', 1 )
    end
  end
end
