require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class Customer < Fortnox::API::Mapper::Base

        KEY_MAP = {
          vat_type: 'VATType',
          vat_number: 'VATNumber',
          email_invoice_bcc: 'EmailInvoiceBCC',
          email_invoice_cc: 'EmailInvoiceCC',
          email_offer_bcc: 'EmailOfferBCC',
          email_offer_cc: 'EmailOfferCC',
          email_order_bcc: 'EmailOrderBCC',
          email_order_cc: 'EmailOrderCC',
          show_price_vat_included: 'ShowPriceVATIncluded',
        }.freeze

        def initialize
          super( KEY_MAP )
        end
      end
    end
  end
end
