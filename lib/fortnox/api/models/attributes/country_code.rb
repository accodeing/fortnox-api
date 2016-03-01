require "virtus"

module Fortnox::API::Model
  module Attribute
    module CountryCode

      include Virtus.module

      attribute :country_code, String

      def country_code=( country_code )
        super country_code.upcase[0...2]
      end

    end
  end
end
