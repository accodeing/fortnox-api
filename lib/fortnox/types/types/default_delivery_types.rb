# frozen_string_literal: true

require 'rest_easy/model'

module Fortnox
  module Types
    class DefaultDeliveryTypesClass < RestEasy::Model
      # Default delivery type for invoices. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :invoice, Types::DefaultDeliveryType

      # Default delivery type for orders. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :order, Types::DefaultDeliveryType

      # Default delivery type for offers. Can be PRINT EMAIL or PRINTSERVICE.
      attribute? :offer, Types::DefaultDeliveryType
    end

    DefaultDeliveryTypes = Types.Constructor( DefaultDeliveryTypesClass )
  end
end
