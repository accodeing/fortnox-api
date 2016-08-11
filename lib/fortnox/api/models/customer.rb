require "fortnox/api/types"
require "fortnox/api/models/second_base"

module Fortnox
  module API
    module Model
      class Customer < Fortnox::API::Model::SecondBase

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

        #Address1	First address of the customer
        attribute :address1, Fortnox::API::Types::Nullable::String

        #Address2	Second address of the customer
        attribute :address2, Fortnox::API::Types::Nullable::String

        #City	City of the customer
        attribute :city, Fortnox::API::Types::Nullable::String

        #Country	Country of the customer
        attribute :country, Fortnox::API::Types::Nullable::String

        #Comments	Comments
        attribute :comments, Fortnox::API::Types::Nullable::String

        #Currency	Currency of the customer, 3 letters
        attribute :currency, Fortnox::API::Types::Currency

        #CostCenter	Cost center of the customer, Cost center in Fortnox
        attribute :cost_center, Fortnox::API::Types::Nullable::String

        #CountryCode	Country code of the customer, 2 letters
        attribute :country_code, Fortnox::API::Types::CountryCode

        #CustomerNumber	Customer number
        attribute :customer_number, Fortnox::API::Types::Nullable::String

        #DeliveryAddress1	First delivery address of the customer
        attribute :delivery_address1, Fortnox::API::Types::Nullable::String

        #DeliveryAddress2	Second delivery address of the customer
        attribute :delivery_address2, Fortnox::API::Types::Nullable::String

        #DeliveryCity	Delivery city of the customer
        attribute :delivery_city, Fortnox::API::Types::Nullable::String

        #DeliveryCountry	Delivery country of the customer
        attribute :delivery_country, Fortnox::API::Types::Nullable::String

        #DeliveryCountryCode	Delivery country code of the customer
        attribute :delivery_country_code, Fortnox::API::Types::Nullable::String

        #DeliveryFax	Delivery fax number of the customer
        attribute :delivery_fax, Fortnox::API::Types::Nullable::String

        #DeliveryName	Delivery name of the customer
        attribute :delivery_name, Fortnox::API::Types::Nullable::String

        #DeliveryPhone1	First delivery phone number of the customer
        attribute :delivery_phone1, Fortnox::API::Types::Nullable::String

        #DeliveryPhone2	Second delivery phone number of the customer
        attribute :delivery_phone2, Fortnox::API::Types::Nullable::String

        #DeliveryZipCode	Delivery zip code of the customer
        attribute :delivery_zip_code, Fortnox::API::Types::Nullable::String

        #Email	Email address of the customer
        attribute :email, Fortnox::API::Types::Nullable::String

        #EmailInvoice	Invoice email address of the customer
        attribute :email_invoice, Fortnox::API::Types::Nullable::String

        #EmailInvoiceBCC	Invoice BCC email address of the customer
        attribute :email_invoice_bcc, Fortnox::API::Types::Nullable::String

        #EmailInvoiceCC	Invoice CC email address of the customer
        attribute :email_invoice_cc, Fortnox::API::Types::Nullable::String

        #EmailOffer	Offer email address of the customer
        attribute :email_offer, Fortnox::API::Types::Nullable::String

        #EmailOfferBCC	Offer BCC email address of the customer
        attribute :email_offer_bcc, Fortnox::API::Types::Nullable::String

        #EmailOfferCC	Offer CC email address of the customer
        attribute :email_offer_cc, Fortnox::API::Types::Nullable::String

        #EmailOrder	Order email address of the customer
        attribute :email_order, Fortnox::API::Types::Nullable::String

        #EmailOrderBCC	Order BCC email address of the customer
        attribute :email_order_bcc, Fortnox::API::Types::Nullable::String

        #EmailOrderCC	Order CC email address of the customer
        attribute :email_order_cc, Fortnox::API::Types::Nullable::String

        #Fax	Fax number of the customer
        attribute :fax, Fortnox::API::Types::Nullable::String

        #InvoiceAdministrationFee  Invoice administration fee of the customer
        attribute :invoice_administration_fee, Fortnox::API::Types::Nullable::Float

        #InvoiceDiscount	Invoice discount of the customer
        attribute :invoice_discount, Fortnox::API::Types::Nullable::Float

        #InvoiceFreight	Invoice freight fee of the customer
        attribute :invoice_freight, Fortnox::API::Types::Nullable::Float

        #InvoiceRemark	Invoice remark of the customer
        attribute :invoice_remark, Fortnox::API::Types::Nullable::String

        #Name	Name of the customer
        attribute :name, Fortnox::API::Types::Required::String

        #OrganisationNumber	Organisation number of the customer
        attribute :organisation_number, Fortnox::API::Types::Nullable::String

        #OurReference	Our reference of the customer
        attribute :our_reference, Fortnox::API::Types::Nullable::String

        #Phone1	First phone number of the customer
        attribute :phone1, Fortnox::API::Types::Nullable::String

        #Phone2	Second phone number of the customer
        attribute :phone2, Fortnox::API::Types::Nullable::String

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

        #VisitAddress	Visit address of the customer
        attribute :visiting_address, Fortnox::API::Types::Nullable::String

        #VisitCity	Visit city of the customer
        attribute :visiting_city, Fortnox::API::Types::Nullable::String

        #VisitCountry	Visit country of the customer
        attribute :visiting_country, Fortnox::API::Types::Nullable::String

        #VisitZipCode	Visit zip code of the customer
        attribute :visiting_zip_code, Fortnox::API::Types::Nullable::String

        #WayOfDeliveryCode	Way of delivery code of the customer
        attribute :way_of_delivery, Fortnox::API::Types::Nullable::String

        #YourReference	Your reference of the customer
        attribute :your_reference, Fortnox::API::Types::Nullable::String

        #ZipCode	Zip code of the customer
        attribute :zip_code, Fortnox::API::Types::Nullable::String

      end
    end
  end
end
