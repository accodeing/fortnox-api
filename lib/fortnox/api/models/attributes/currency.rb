require "virtus"

module Fortnox
  module API
    module Model
      module Attribute
        module Currency

          include Virtus.module

          attribute :currency, String

          def currency=( raw_currency )
            super raw_currency.upcase[0...3]
          end

        end
      end
    end
  end
end
