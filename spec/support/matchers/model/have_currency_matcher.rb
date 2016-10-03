module Matchers
  module Model
    def have_currency( attribute, valid_hash )
      HaveCurrencyMatcher.new( attribute, valid_hash )
    end

    class HaveCurrencyMatcher < EnumMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'currency', 'Currency', 'Currencies' )
      end
    end
  end
end
