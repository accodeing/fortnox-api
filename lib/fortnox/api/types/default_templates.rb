# frozen_string_literal: true

module Fortnox
  module API
    module Types
      class DefaultTemplates < Types::Model
        STUB = {}.freeze

        # Default template for orders. Must be a name of an existing print template.
        attribute :order, Types::Required::String

        # Default template for offers. Must be a name of an existing print template.
        attribute :offer, Types::Required::String

        # Default template for invoices. Must be a name of an existing print template.
        attribute :invoice, Types::Required::String

        # Default template for cash invoices. Must be a name of an existing print template.
        attribute :cash_invoice, Types::Required::String
      end
    end
  end
end
