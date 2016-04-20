require "fortnox/api/models/order_base"
require "fortnox/api/models/order_row"

module Fortnox
  module API
    module Model
      class Order < Fortnox::API::Model::Base
        include OrderBase

        #CopyRemarks I remarks shall copies from order to invoice
        attribute :copy_remarks, Boolean

        # InvoiceReference Reference if an invoice is created from order
        attribute :invoice_reference, Integer, writer: :private

        # OrderDate Date of order
        attribute :order_date, Date

        # OrderRows Separate object
        attribute :order_rows, Array[OrderRow]
      end
    end
  end
end
