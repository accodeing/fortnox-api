require "virtus"

module Fortnox
  module API
    module Model
      module Attribute
        module CountryCode

          include Virtus.module

          attribute :country_code, String

          def country_code=( raw_country_code )
            super raw_country_code.upcase[0...2]
          end

        end
      end
    end
  end
end
