# frozen_string_literal: true

require 'fortnox/api/types'
require 'fortnox/api/models/label'

module Fortnox
  module API
    module Model
      # This model is the shared attributes for Offer, Order and Invoice, the three "docuemnt models" in Fortnox.
      # In the Fortnox implementation these are so close together that they are saved in the same database table.
      # This is never used standalone, only included in the respective models.
      class Document < Fortnox::API::Model::Base
        # Url Direct url to the record.
        attribute :url, Types::Nullable::String.is(:read_only)

        # AdministrationFee The document administration fee.
        attribute :administration_fee, Types::Nullable::Float

        # AdministrationFeeVAT VAT of the document administration fee.
        attribute :administration_fee_vat, Types::Nullable::Float.is(:read_only)

        # Address1 Document address 1. 1024 characters
        attribute :address1, Types::Sized::String[1024]

        # Address2 Document address 2. 1024 characters
        attribute :address2, Types::Sized::String[1024]

        # BasisTaxReduction Basis of tax reduction.
        attribute :basis_tax_reduction, Types::Nullable::Float.is(:read_only)

        # Cancelled If the document is cancelled.
        attribute :cancelled, Types::Nullable::Boolean.is(:read_only)

        # City City for the document address.
        attribute :city, Types::Sized::String[1024]

        # Comments Comments of the document
        attribute :comments, Types::Sized::String[1024]

        # ContributionPercent Document contribution in percent.
        attribute :contribution_percent, Types::Nullable::Float.is(:read_only)

        # ContributionValue Document contribution in amount.
        attribute :contribution_value, Types::Nullable::Float.is(:read_only)

        # Country Country for the document address.
        attribute :country, Types::CountryCode

        # CostCenter Code of the cost center.
        attribute :cost_center, Types::Nullable::String

        # Currency Code of the currency.
        attribute :currency, Types::Currency

        # CurrencyRate Currency rate used for the document
        attribute :currency_rate, Types::Nullable::Float

        # CurrencyUnit Currency unit used for the document
        attribute :currency_unit, Types::Nullable::Float

        # CustomerName Name of the customer. 1024 characters
        attribute :customer_name, Types::Sized::String[1024]

        # CustomerNumber Customer number of the customer. Required
        attribute :customer_number, Types::Required::String

        # DeliveryAddress1 Document delivery address 1.
        attribute :delivery_address1, Types::Sized::String[1024]

        # DeliveryAddress2 Document delivery address 2.
        attribute :delivery_address2, Types::Sized::String[1024]

        # DeliveryCity City for the document delivery address.
        attribute :delivery_city, Types::Sized::String[1024]

        # DeliveryCountry Country for the document delivery address.
        attribute :delivery_country, Types::CountryCode

        # DeliveryDate Date of delivery.
        attribute :delivery_date, Types::Nullable::Date

        # DeliveryName  Name of the recipient of the delivery
        attribute :delivery_name, Types::Sized::String[1024]

        # DeliveryZipCode ZipCode for the document delivery address.
        attribute :delivery_zip_code, Types::Sized::String[1024]

        # DocumentNumber The document number.
        attribute :document_number, Types::Nullable::Integer

        # EmailInformation Separete EmailInformation object
        attribute :email_information, Types::EmailInformation

        # ExternalInvoiceReference1 External document reference 1. 80 characters
        attribute :external_invoice_reference1, Types::Sized::String[80]

        # ExternalInvoiceReference2 External document reference 2. 80 characters
        attribute :external_invoice_reference2, Types::Sized::String[80]

        # Freight Freight cost of the document. 12 digits (incl. decimals)
        attribute :freight, Types::Sized::Float[0.0, 99_999_999_999.9]

        # FreightVAT VAT of the freight cost.
        attribute :freight_vat, Types::Nullable::Float.is(:read_only)

        # Gross Gross value of the document
        attribute :gross, Types::Nullable::Float.is(:read_only)

        # HouseWork If there is any row of the document marked "housework".
        attribute :housework, Types::Nullable::Boolean.is(:read_only)

        attribute :labels, Types::Strict::Array.member(Label)

        # Net Net amount
        attribute :net, Types::Nullable::Float.is(:read_only)

        # NotCompleted If the document is set as not completed.
        attribute :not_completed, Types::Nullable::Boolean

        # OfferReference Reference to the offer, if one exists.
        attribute :offer_reference, Types::Nullable::Integer.is(:read_only)

        # OrganisationNumber Organisation number of the customer for the
        # document.
        attribute :organisation_number, Types::Nullable::String.is(:read_only)

        # OurReference Our reference. 50 characters
        attribute :our_reference, Types::Sized::String[50]

        # Phone1 Phone number 1 of the customer for the document. 1024 characters
        attribute :phone1, Types::Sized::String[1024]

        # Phone2 Phone number 2 of the customer for the document. 1024 characters
        attribute :phone2, Types::Sized::String[1024]

        # PriceList Code of the price list.
        attribute :price_list, Types::Nullable::String

        # PrintTemplate Print template of the document.
        attribute :print_template, Types::Nullable::String

        # Project Code of the project.
        attribute :project, Types::Nullable::String

        # Remarks Remarks of the document. 1024 characters
        attribute :remarks, Types::Sized::String[1024]

        # RoundOff Round off amount for the document.
        attribute :round_off, Types::Nullable::Float.is(:read_only)

        # Sent If the document is printed or sent in any way.
        attribute :sent, Types::Nullable::Boolean.is(:read_only)

        # TaxReduction The amount of tax reduction.
        attribute :tax_reduction, Types::Nullable::Integer.is(:read_only)

        # TermsOfDelivery Code of the terms of delivery.
        attribute :terms_of_delivery, Types::Nullable::String

        # TermsOfPayment Code of the terms of payment.
        attribute :terms_of_payment, Types::Nullable::String

        # Total The total amount of the document.
        attribute :total, Types::Nullable::Float.is(:read_only)

        # TotalVAT The total VAT amount of the document.
        attribute :total_vat, Types::Nullable::Float.is(:read_only)

        # VATIncluded If the price of the document is including VAT.
        attribute :vat_included, Types::Nullable::Boolean

        # WayOfDelivery Code of the way of delivery.
        attribute :way_of_delivery, Types::Nullable::String

        # YourOrderNumber Your order number. 30 characters
        attribute :your_order_number, Types::Sized::String[30]

        # YourReference Your reference. 50 characters
        attribute :your_reference, Types::Sized::String[50]

        # ZipCode Zip code of the document. 1024 characters
        attribute :zip_code, Types::Sized::String[1024]
      end
    end
  end
end
