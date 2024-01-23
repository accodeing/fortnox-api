# frozen_string_literal: true

require_relative 'base'
require_relative 'document'

module Fortnox
  module API
    module Model
      class Order < Document
        UNIQUE_ID = :document_number
        STUB = { customer_number: '', order_rows: [] }.freeze

        # CopyRemarks I remarks shall copies from order to invoice
        attribute :copy_remarks, Types::Nullable::Boolean

        # InvoiceReference Reference if an invoice is created from order
        attribute :invoice_reference, Types::Nullable::Integer.is(:read_only)

        # OrderDate Date of order
        attribute :order_date, Types::Nullable::Date

        # OrderRows Separate object
        attribute :order_rows, Types::Strict::Array.of(Types::OrderRow)
      end
    end
  end
end
