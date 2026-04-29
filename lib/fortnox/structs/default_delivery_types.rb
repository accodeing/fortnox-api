# frozen_string_literal: true

module Fortnox
  module Structs
    class DefaultDeliveryTypes < Fortnox::Struct
      # Default delivery type for invoices. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :invoice, Types::DefaultDeliveryTypeValues

      # Default delivery type for orders. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :order, Types::DefaultDeliveryTypeValues

      # Default delivery type for offers. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :offer, Types::DefaultDeliveryTypeValues
    end
  end
end
