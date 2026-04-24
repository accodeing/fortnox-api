# frozen_string_literal: true

require 'countries'

module Fortnox
  module Mappers
    module CountryCode
      ISO3166.configure { |config| config.locales = [:en, :sv] }

      def self.parse(country)
        return '' if country.nil? || country == ''

        # Fortnox only supports Swedish translation of Sweden
        return 'SE' if country =~ /^s(e$|we|ve)/i

        country = ::ISO3166::Country[country] ||
                  ::ISO3166::Country.find_country_by_iso_short_name(country) ||
                  ::ISO3166::Country.find_country_by_translated_names(country)

        raise Fortnox::AttributeError, '"Country" violates constraints' if country.nil?

        country.alpha2
      end

      def self.serialise(country_code)
        return '' if country_code.nil? || country_code == ''

        return 'Sverige' if country_code == 'SE'

        ::ISO3166::Country.new(country_code).translations['en']
      end
    end
  end
end
