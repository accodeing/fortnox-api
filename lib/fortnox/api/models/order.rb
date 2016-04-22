require "fortnox/api/models/document_base"
require "fortnox/api/models/order_row"

module Fortnox
  module API
    module Model
      class Order < Fortnox::API::Model::Base
        include DocumentBase

        #CopyRemarks I remarks shall copies from order to invoice
        attribute :copy_remarks, Boolean

        # InvoiceReference Reference if an invoice is created from order
        # TODO: Writer should be private!
        attribute :invoice_reference, Integer

        # OrderDate Date of order
        attribute :order_date, Date

        # OrderRows Separate object
        attribute :order_rows, Array[OrderRow]

        # Override to_hash to convert nested OrderRows to hash correctly.
        def to_hash *args
          main_hash = super
          main_hash[:order_rows] = self.order_rows.map(&:to_hash)
          main_hash
        end
      end
    end
  end
end
