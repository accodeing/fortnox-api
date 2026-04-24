# frozen_string_literal: true

module Fortnox
  class Order < Document
    using RestEasy::Refinements

    configure do
      path 'orders'
      instance_wrapper 'Order'
      collection_wrapper 'Orders'
    end

    # CopyRemarks If remarks shall be copied from order to invoice
    attr :copy_remarks, Bool.optional, Boolean

    # InvoiceReference Reference if an invoice is created from order
    attr :invoice_reference, Coercible::Integer.optional, :read_only

    # OrderDate Date of order
    attr :order_date, Date.optional, Mappers::Date

    # OrderRows Separate object
    attr :order_rows, Strict::Array.of(Structs::OrderRow), Mappers::StructArray.for(Structs::OrderRow)

    # TODO: new attribute
    attr :delivery_state, Coercible::String.optional

    # TODO: new attribute
    attr :order_type, Coercible::String.optional

    # TODO: new attribute
    attr :stock_point_code, Coercible::String.optional

    # TODO: new attribute
    attr :stock_point_id, Coercible::String.optional
  end
end
