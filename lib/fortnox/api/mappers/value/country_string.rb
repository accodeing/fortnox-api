# frozen_string_literal: true

require_relative '../base/canonical_name_sym'

module Fortnox
  module API
    module Mapper
      class CountryString
        extend CanonicalNameSym

        CountryMapper = lambda do |code|
          next code if code.nil? || code == ''

          # Fortnox only supports Swedish country name for Sweden
          next 'Sverige' if code == 'SE'

          ::ISO3166::Country[code].translations['en']
        end

        Registry.register(canonical_name_sym, CountryMapper)
      end
    end
  end
end
