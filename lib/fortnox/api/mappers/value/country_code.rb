module Fortnox
  module API
    module Mapper
      CountryCode = lambda do |code|
        next 'Sverige' if code == 'SE'

        ::ISO3166::Country[code].translations['en']
      end

      Registry.register(:countrycodestring, CountryCode)
    end
  end
end
