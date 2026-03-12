# frozen_string_literal: true

module Fortnox
  class Order < Document
    using RestEasy::Refinements

    configure do
      path "orders"
      instance_wrapper "Order"
      collection_wrapper "Orders"
    end

    # CopyRemarks If remarks shall be copied from order to invoice
    attr :copy_remarks, Nullable::Boolean

    # InvoiceReference Reference if an invoice is created from order
    attr :invoice_reference, Nullable::Integer, :read_only

    # OrderDate Date of order
    attr :order_date, Nullable::Date

    # OrderRows Separate object
    attr :order_rows, Strict::Array.of(OrderRow)

    # TODO: new attribute
    attr :delivery_state, Nullable::String

    # TODO: new attribute
    attr :order_type, Nullable::String

    # TODO: new attribute
    attr :stock_point_code, Nullable::String

    # TODO: new attribute
    attr :stock_point_id, Nullable::String
  end
end
