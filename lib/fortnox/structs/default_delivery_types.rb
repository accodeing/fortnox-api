# frozen_string_literal: true

module Fortnox
  module Structs
    class DefaultDeliveryTypes < Fortnox::Struct
      # Default delivery type for invoices. Can be PRINT EMAIL or PRINTSERVICE.
      attr :invoice, Types::DefaultDeliveryTypeValues

      # Default delivery type for orders. Can be PRINT EMAIL or PRINTSERVICE.
      attr :order, Types::DefaultDeliveryTypeValues

      # Default delivery type for offers. Can be PRINT EMAIL or PRINTSERVICE.
      attr :offer, Types::DefaultDeliveryTypeValues
    end
  end
end
