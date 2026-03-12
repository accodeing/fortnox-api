# frozen_string_literal: true

module Fortnox
  module Types
    class DefaultDeliveryTypes < Dry::Struct
      # Default delivery type for invoices. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :invoice, DefaultDeliveryTypes

      # Default delivery type for orders. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :order, DefaultDeliveryTypes

      # Default delivery type for offers. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :offer, DefaultDeliveryTypes
    end
  end
end
