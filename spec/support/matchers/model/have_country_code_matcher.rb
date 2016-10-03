module Matchers
  module Model
    def have_country_code( attribute, valid_hash = {} )
      HaveCountryCodeMatcher.new( attribute, valid_hash )
    end

    class HaveCountryCodeMatcher < EnumMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'country code', 'CountryCode', 'CountryCodes' )
      end
    end
  end
end
