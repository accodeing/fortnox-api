require "fortnox/api/types"
require "fortnox/api/models/base"

module Fortnox
  module API
    module Model
      class Customer < Fortnox::API::Model::Base

        # searchable_attributes(
        #     :city, :customer_number, :email, :name, :organisation_number,
        #     :phone1, :zip_code
        # )
        #
        # sortable_attributes(
        #   :customer_number, :name
        # )
        #
        # filter(
        #   :active
        # )
        #
        # actions(
        #   :hire
        # )

        #Url	Direct URL to the record
        attribute :url, Fortnox::API::Types::Nullable::String.with( read_only: true )

        #Address1	First address of the customer. 1024 characters
        attribute :address1, Fortnox::API::Types::Sized::String[ 1024 ]

        #Address2	Second address of the customer. 1024 characters
        attribute :address2, Fortnox::API::Types::Sized::String[ 1024 ]

        #City	City of the customer. 1024 characters
        attribute :city, Fortnox::API::Types::Sized::String[ 1024 ]

        #Country	Country of the customer. Read-only.
        attribute :country, Fortnox::API::Types::Nullable::String.with( read_only: true )

        #Comments	Comments. 1024 characters.
        attribute :comments, Fortnox::API::Types::Sized::String[ 1024 ]

        #Currency	Currency of the customer, 3 letters
        attribute :currency, Fortnox::API::Types::Currency

        #CostCenter	Cost center of the customer, Cost center in Fortnox
        attribute :cost_center, Fortnox::API::Types::Nullable::String

        #CountryCode	Country code of the customer, 2 letters
        attribute :country_code, Fortnox::API::Types::CountryCode

        #CustomerNumber	Customer number. 1024 characters
        attribute :customer_number, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryAddress1	First delivery address of the customer. 1024 characters
        attribute :delivery_address1, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryAddress2	Second delivery address of the customer. 1024 characters
        attribute :delivery_address2, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryCity	Delivery city of the customer. 1024 characters
        attribute :delivery_city, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryCountry	Delivery country of the customer. Read-only.
        attribute :delivery_country, Fortnox::API::Types::Nullable::String.with( read_only: true )

        #DeliveryCountryCode	Delivery country code of the customer, 2 letters
        attribute :delivery_country_code, Fortnox::API::Types::CountryCode

        #DeliveryFax	Delivery fax number of the customer. 1024 characters
        attribute :delivery_fax, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryName	Delivery name of the customer. 1024 characters
        attribute :delivery_name, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryPhone1	First delivery phone number of the customer. 1024 characters
        attribute :delivery_phone1, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryPhone2	Second delivery phone number of the customer. 1024 characters
        attribute :delivery_phone2, Fortnox::API::Types::Sized::String[ 1024 ]

        #DeliveryZipCode	Delivery zip code of the customer. 1024 characters.
        attribute :delivery_zip_code, Fortnox::API::Types::Sized::String[ 1024 ]

        #Email	Email address of the customer. 1024 characters
        attribute :email, Types::Email

        #EmailInvoice	Invoice email address of the customer. 1024 characters
        attribute :email_invoice, Types::Email

        #EmailInvoiceBCC	Invoice BCC email address of the customer. 1024 characters
        attribute :email_invoice_bcc, Types::Email

        #EmailInvoiceCC	Invoice CC email address of the customer. 1024 characters
        attribute :email_invoice_cc, Types::Email

        #EmailOffer	Offer email address of the customer. 1024 characters
        attribute :email_offer, Types::Email

        #EmailOfferBCC	Offer BCC email address of the customer. 1024 characters
        attribute :email_offer_bcc, Types::Email

        #EmailOfferCC	Offer CC email address of the customer. 1024 characters
        attribute :email_offer_cc, Types::Email

        #EmailOrder	Order email address of the customer. 1024 characters
        attribute :email_order, Types::Email

        #EmailOrderBCC	Order BCC email address of the customer. 1024 characters
        attribute :email_order_bcc, Types::Email

        #EmailOrderCC	Order CC email address of the customer. 1024 characters
        attribute :email_order_cc, Types::Email

        #Fax	Fax number of the customer. 1024 characters
        attribute :fax, Fortnox::API::Types::Sized::String[ 1024 ]

        #InvoiceAdministrationFee  Invoice administration fee of the customer, 12 digits (incl. decimals).
        attribute :invoice_administration_fee,
                  Fortnox::API::Types::Sized::Float[ 0.0, 99_999_999_999.0 ]

        #InvoiceDiscount	Invoice discount of the customer, 12 digits (incl. decimals)
        attribute :invoice_discount, Fortnox::API::Types::Sized::Float[ 0.0, 99_999_999_999.0 ]

        #InvoiceFreight	Invoice freight fee of the customer, 12 digits (incl. decimals)
        attribute :invoice_freight, Fortnox::API::Types::Sized::Float[ 0.0, 99_999_999_999.0 ]

        #InvoiceRemark	Invoice remark of the customer. 1024 characters
        attribute :invoice_remark, Fortnox::API::Types::Sized::String[ 1024 ]

        #Name	Name of the customer, 1024 characters
        attribute :name, Fortnox::API::Types::Sized::String[ 1024 ].with( required: true )

        #OrganisationNumber	Organisation number of the customer. 30 characters
        attribute :organisation_number, Fortnox::API::Types::Sized::String[ 30 ]

        #OurReference	Our reference of the customer. 50 characters
        attribute :our_reference, Fortnox::API::Types::Sized::String[ 50 ]

        #Phone1	First phone number of the customer. 1024 characters
        attribute :phone1, Fortnox::API::Types::Sized::String[ 1024 ]

        #Phone2	Second phone number of the customer. 1024 characters
        attribute :phone2, Fortnox::API::Types::Sized::String[ 1024 ]

        #PriceList	Price list of the customer, Price list in Fortnox
        attribute :price_list, Fortnox::API::Types::Nullable::String

        #Project	Project of the customer, Project in Fortnox
        attribute :project, Fortnox::API::Types::Nullable::Integer

        #SalesAccount	Sales account of the customer, 4 digits
        attribute :sales_account, Fortnox::API::Types::AccountNumber

        #ShowPriceVATIncluded	Show prices with VAT included or not
        attribute :show_price_vat_included, Fortnox::API::Types::Nullable::Boolean

        #TermsOfDeliveryCode	Terms of delivery code of the customer
        attribute :terms_of_delivery, Fortnox::API::Types::Nullable::String

        #TermsOfPaymentCode	Terms of payment code of the customer
        attribute :terms_of_payment, Fortnox::API::Types::Nullable::String

        #Type	Customer type, PRIVATE / COMPANY
        attribute :type, Fortnox::API::Types::CustomerType

        #VATNumber	VAT number of the customer
        attribute :vat_number, Fortnox::API::Types::Nullable::String

        #VATType	VAT type of the customer, SEVAT / SEREVERSEDVAT / EUREVERSEDVAT / EUVAT / EXPORT
        attribute :vat_type, Fortnox::API::Types::VATType

        #VisitAddress	Visit address of the customer. 128 characters
        attribute :visiting_address, Fortnox::API::Types::Sized::String[ 128 ]

        #VisitCity	Visit city of the customer. 128 characters
        attribute :visiting_city, Fortnox::API::Types::Sized::String[ 128 ]

        #VisitCountry	Visit country of the customer, read-only
        attribute :visiting_country, Fortnox::API::Types::Nullable::String.with( read_only: true )

        #VisitingCountryCode Code of the visiting country for the customer, 2 letters
        attribute :visiting_country_code, Fortnox::API::Types::CountryCode

        #VisitZipCode	Visit zip code of the customer. 10 characters
        attribute :visiting_zip_code, Fortnox::API::Types::Sized::String[ 10 ]

        #WayOfDeliveryCode	Way of delivery code of the customer
        attribute :way_of_delivery, Fortnox::API::Types::Nullable::String

        #YourReference	Your reference of the customer. 50 characters
        attribute :your_reference, Fortnox::API::Types::Sized::String[ 50 ]

        #ZipCode	Zip code of the customer. 10 characters
        attribute :zip_code, Fortnox::API::Types::Sized::String[ 10 ]

      end
    end
  end
end
