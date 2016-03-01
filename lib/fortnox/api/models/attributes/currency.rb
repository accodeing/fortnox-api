require "virtus"

module Fortnox::API::Model
  module Attribute
    module Currency

      include Virtus.module

      attribute :currency, String

      def currency=( currency )
        super currency.upcase[0...3]
      end

    end
  end
end
