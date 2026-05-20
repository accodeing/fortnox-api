# frozen_string_literal: true

module Fortnox
  module Structs
    class DefaultDeliveryTypes < Fortnox::Struct
      # Default delivery type for invoices.
      attribute? :invoice, Types::DefaultInvoiceDeliveryTypeValues

      # Default delivery type for orders.
      attribute? :order, Types::DefaultDeliveryTypeValues

      # Default delivery type for offers.
      attribute? :offer, Types::DefaultDeliveryTypeValues
    end
  end
end
