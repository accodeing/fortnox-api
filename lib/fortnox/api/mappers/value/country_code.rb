# frozen_string_literal: true

require 'fortnox/api/mappers/base/canonical_name_sym'

module Fortnox
  module API
    module Mapper
      extend CanonicalNameSym

      CountryCode = lambda do |code|
        # Fortnox only supports Swedish country name for Sweden
        next 'Sverige' if code == 'SE'

        ::ISO3166::Country[code].translations['en']
      end

      Registry.register(:countrycodestring, CountryCode)

      Registry.register(self.canonical_name_sym, CountryCode)
    end
  end
end
