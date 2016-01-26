require "fortnox/api/models/repository/base"
require "fortnox/api/models/customer/entity"

module Fortnox
  module API
    module Repositories
      class Customer < Fortnox::API::Repository::Base

        def initialize
          super(
            base_uri: '/customers/',
            json_list_wrapper: 'Customers',
            json_unit_wrapper: 'Customer',
            unique_id: 'CustomerNumber',
            attribut_name_to_json_key_map: {
              vat_type: 'VATType',
              vat_number: 'VATNumber',
              email_invoice_bcc: 'EmailInvoiceBCC',
              email_invoice_cc: 'EmailInvoiceCC',
              email_offer_bcc: 'EmailOfferBCC',
              email_offer_cc: 'EmailOfferCC',
              email_order_bcc: 'EmailOrderBCC',
              email_order_cc: 'EmailOrderCC',
              show_price_vat_included: 'ShowPriceVATIncluded',
            },
            keys_filtered_on_save: [
              :url,
            ]
          )
        end

      private

        def instansiate( hash )
          hash[ 'new' ] = false
          Fortnox::API::Entities::Customer.new( hash )
        end

      end
    end
  end
end
