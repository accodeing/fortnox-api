require "fortnox/api/models/base"
require "fortnox/api/models/document_base"
require "fortnox/api/models/order_row"

module Fortnox
  module API
    module Model
      class Order < Fortnox::API::Model::Base
        DocumentBase.ify( self )

        #CopyRemarks I remarks shall copies from order to invoice
        attribute :copy_remarks, Types::Nullable::Boolean

        # InvoiceReference Reference if an invoice is created from order
        attribute :invoice_reference, Types::Nullable::Integer.with( read_only: true )

        # OrderDate Date of order
        attribute :order_date, Types::Nullable::Date

        # OrderRows Separate object
        attribute :order_rows, Types::Strict::Array.member( OrderRow )

        # Override to_hash to convert nested OrderRows to hash correctly.
        def to_hash *args
          hash = super
          hash[:order_rows] = self.order_rows.map(&:to_hash) unless self.order_rows.nil?

          hash
        end
      end
    end
  end
end
