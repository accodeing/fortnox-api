# frozen_string_literal: true

module Fortnox
  module Structs
    class DefaultTemplates < Fortnox::Struct
      # Default template for orders. Must be a name of an existing print template.
      attribute? :order, Types::Strict::String

      # Default template for offers. Must be a name of an existing print template.
      attribute? :offer, Types::Strict::String

      # Default template for invoices. Must be a name of an existing print template.
      attribute? :invoice, Types::Strict::String

      # Default template for cash invoices. Must be a name of an existing print template.
      attribute? :cash_invoice, Types::Strict::String
    end
  end
end
