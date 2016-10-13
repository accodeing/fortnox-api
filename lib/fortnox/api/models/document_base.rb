require "fortnox/api/types"
require "fortnox/api/models/label"
require "fortnox/api/models/email_information"

module Fortnox
  module API
    module Model
      module DocumentBase
        # Method length is ignored due to readability.
        # rubocop:disable Metrics/MethodLength
        def self.ify( base )
          base.class_eval do

            # Url Direct url to the record.
            base.attribute :url, Types::Nullable::String.with( read_only: true )

            # AdministrationFee The document administration fee.
            base.attribute :administration_fee, Types::Nullable::Float

            # AdministrationFeeVAT VAT of the document administration fee.
            base.attribute :administration_fee_vat, Types::Nullable::Float.with( read_only: true )

            # Address1 Document address 1. 1024 characters
            base.attribute :address1, Types::Sized::String[ 1024 ]

            # Address2 Document address 2. 1024 characters
            base.attribute :address2, Types::Sized::String[ 1024 ]

            # BasisTaxReduction Basis of tax reduction.
            base.attribute :basis_tax_reduction, Types::Nullable::Float.with( read_only: true )

            # Cancelled If the document is cancelled.
            base.attribute :cancelled, Types::Nullable::Boolean.with( read_only: true )

            # City City for the document address.
            base.attribute :city, Types::Sized::String[ 1024 ]

            # Comments Comments of the document
            base.attribute :comments, Types::Sized::String[ 1024 ]

            # ContributionPercent Document contribution in percent.
            base.attribute :contribution_percent, Types::Nullable::Float.with( read_only: true )

            # ContributionValue Document contribution in amount.
            base.attribute :contribution_value, Types::Nullable::Float.with( read_only: true )

            # Country Country for the document address.
            base.attribute :country, Fortnox::API::Types::CountryCode

            # CostCenter Code of the cost center.
            base.attribute :cost_center, Types::Nullable::String

            # Currency Code of the currency.
            base.attribute :currency, Fortnox::API::Types::Currency

            # CurrencyRate Currency rate used for the document
            base.attribute :currency_rate, Types::Nullable::Float

            # CurrencyUnit Currency unit used for the document
            base.attribute :currency_unit, Types::Nullable::Float

            # CustomerName Name of the customer. 1024 characters
            base.attribute :customer_name, Types::Sized::String[ 1024 ]

            # CustomerNumber Customer number of the customer. Required
            base.attribute :customer_number, Types::Required::String

            # DeliveryAddress1 Document delivery address 1.
            base.attribute :delivery_address1, Types::Sized::String[ 1024 ]

            # DeliveryAddress2 Document delivery address 2.
            base.attribute :delivery_address2, Types::Sized::String[ 1024 ]

            # DeliveryCity City for the document delivery address.
            base.attribute :delivery_city, Types::Sized::String[ 1024 ]

            # DeliveryCountry Country for the document delivery address.
            base.attribute :delivery_country, Fortnox::API::Types::CountryCode

            # DeliveryDate Date of delivery.
            base.attribute :delivery_date, Types::Nullable::Date

            # DeliveryName  Name of the recipient of the delivery
            base.attribute :delivery_name, Types::Sized::String[ 1024 ]

            # DeliveryZipCode ZipCode for the document delivery address.
            base.attribute :delivery_zip_code, Types::Sized::String[ 1024 ]

            # DocumentNumber The document number.
            base.attribute :document_number, Types::Nullable::Integer

            # EmailInformation Separete EmailInformation object
            base.attribute :email_information, EmailInformation

            # ExternalInvoiceReference1 External document reference 1. 80 characters
            base.attribute :external_invoice_reference1, Types::Sized::String[ 80 ]

            # ExternalInvoiceReference2 External document reference 2. 80 characters
            base.attribute :external_invoice_reference2, Types::Sized::String[ 80 ]

            # Freight Freight cost of the document. 12 digits (incl. decimals)
            base.attribute :freight, Types::Sized::Float[ 0.0, 99_999_999_999.0 ]

            # FreightVAT VAT of the freight cost.
            base.attribute :freight_vat, Types::Nullable::Float.with( read_only: true )

            # Gross Gross value of the document
            base.attribute :gross, Types::Nullable::Float.with( read_only: true )

            # HouseWork If there is any row of the document marked “house work”.
            base.attribute :house_work, Types::Nullable::Boolean.with( read_only: true )

            base.attribute :labels, Types::Strict::Array.member( Label )

            # Net Net amount
            base.attribute :net, Types::Nullable::Float.with( read_only: true )

            # NotCompleted If the document is set as not completed.
            base.attribute :not_completed, Types::Nullable::Boolean

            # OfferReference Reference to the offer, if one exists.
            base.attribute :offer_reference, Types::Nullable::Integer.with( read_only: true )

            # OrganisationNumber Organisation number of the customer for the
            # document.
            base.attribute :organisation_number, Types::Nullable::String.with( read_only: true )

            # OurReference Our reference. 50 characters
            base.attribute :our_reference, Types::Sized::String[ 50 ]

            # Phone1 Phone number 1 of the customer for the document. 1024 characters
            base.attribute :phone1, Types::Sized::String[ 1024 ]

            # Phone2 Phone number 2 of the customer for the document. 1024 characters
            base.attribute :phone2, Types::Sized::String[ 1024 ]

            # PriceList Code of the price list.
            base.attribute :price_list, Types::Nullable::String

            # PrintTemplate Print template of the document.
            base.attribute :print_template, Types::Nullable::String

            # Project Code of the project.
            base.attribute :project, Types::Nullable::String

            # Remarks Remarks of the document. 1024 characters
            base.attribute :remarks, Types::Sized::String[ 1024 ]

            # RoundOff Round off amount for the document.
            base.attribute :round_off, Types::Nullable::Float.with( read_only: true )

            # Sent If the document is printed or sent in any way.
            base.attribute :sent, Types::Nullable::Boolean.with( read_only: true )

            # TaxReduction The amount of tax reduction.
            base.attribute :tax_reduction, Types::Nullable::Integer.with( read_only: true )

            # TermsOfDelivery Code of the terms of delivery.
            base.attribute :terms_of_delivery, Types::Nullable::String

            # TermsOfPayment Code of the terms of payment.
            base.attribute :terms_of_payment, Types::Nullable::String

            # Total The total amount of the document.
            base.attribute :total, Types::Nullable::Float.with( read_only: true )

            # TotalVAT The total VAT amount of the document.
            base.attribute :total_vat, Types::Nullable::Float.with( read_only: true )

            # VATIncluded If the price of the document is including VAT.
            base.attribute :vat_included, Types::Nullable::Boolean

            # WayOfDelivery Code of the way of delivery.
            base.attribute :way_of_delivery, Types::Nullable::String

            # YourOrderNumber Your order number. 30 characters
            base.attribute :your_order_number, Types::Sized::String[ 30 ]

            # YourReference Your reference. 50 characters
            base.attribute :your_reference, Types::Sized::String[ 50 ]

            # ZipCode Zip code of the document. 1024 characters
            base.attribute :zip_code, Types::Sized::String[ 1024 ]
          end
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
