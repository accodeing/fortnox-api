require "virtus"

module Fortnox
  module API
    module Attributes
      module Currency

        include Virtus.module

        attribute :currency, String

        def currency=( currency )
          super currency.upcase[0...3]
        end

      end
    end
  end
end
