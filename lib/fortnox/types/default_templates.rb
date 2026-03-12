# frozen_string_literal: true

module Fortnox
  module Types
    class DefaultTemplates < Dry::Struct
      transform_keys do |key|
        RestEasy::Conventions::PascalCase.new.parse(key)
      end

      # Default template for orders. Must be a name of an existing print template.
      attribute? :order, Required::String

      # Default template for offers. Must be a name of an existing print template.
      attribute? :offer, Required::String

      # Default template for invoices. Must be a name of an existing print template.
      attribute? :invoice, Required::String

      # Default template for cash invoices. Must be a name of an existing print template.
      attribute? :cash_invoice, Required::String
    end
  end
end
