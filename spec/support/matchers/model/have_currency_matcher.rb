module Matchers
  module Model
    def have_currency( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'Currency', 'Currencies' )
    end
  end
end
