require "virtus"

module Fortnox
  module API
    module Attributes
      module CountryCode

        include Virtus.module

        attribute :country_code, String

        def country_code=( country_code )
          super country_code.upcase[0...2]
        end

      end
    end
  end
end
