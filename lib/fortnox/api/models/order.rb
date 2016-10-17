require "fortnox/api/models/base"
require "fortnox/api/models/document_base"
require "fortnox/api/models/order_row"

module Fortnox
  module API
    module Model
      class Order < Fortnox::API::Model::Base
        UNIQUE_ID = :document_number
        STUB = { customer_number: '', order_rows: [] }.freeze

        DocumentBase.ify( self )

        #CopyRemarks I remarks shall copies from order to invoice
        attribute :copy_remarks, Types::Nullable::Boolean

        # InvoiceReference Reference if an invoice is created from order
        attribute :invoice_reference, Types::Nullable::Integer.with( read_only: true )

        # OrderDate Date of order
        attribute :order_date, Types::Nullable::Date

        # OrderRows Separate object
        attribute :order_rows, Types::Strict::Array.member( OrderRow )
      end
    end
  end
end
