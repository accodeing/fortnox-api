# frozen_string_literal: true

require 'rest_easy/model'

module Fortnox
  module Types
    class DefaultTemplatesClass < RestEasy::Model
      # Default template for orders. Must be a name of an existing print template.
      attribute? :order, Types::Required::String

      # Default template for offers. Must be a name of an existing print template.
      attribute? :offer, Types::Required::String

      # Default template for invoices. Must be a name of an existing print template.
      attribute? :invoice, Types::Required::String

      # Default template for cash invoices. Must be a name of an existing print template.
      attribute? :cash_invoice, Types::Required::String
    end

    DefaultTemplates = Types.Constructor( DefaultTemplatesClass )
  end
end
