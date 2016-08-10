require "fortnox/api/types"
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
            # TODO: Writer should be private!
            base.attribute :url, Types::Nullable::String

            # AdministrationFee The document administration fee. 12 digits (incl. decimals)
            base.attribute :administration_fee, Types::Nullable::Float

            # AdministrationFeeVAT VAT of the document administration fee.
            # TODO: Writer should be private!
            base.attribute :administration_fee_vat, Types::Nullable::Float

            # Address1 Document address 1. 1024 characters
            base.attribute :address1, Types::Nullable::String

            # Address2 Document address 2. 1024 characters
            base.attribute :address2, Types::Nullable::String

            # BasisTaxReduction Basis of tax reduction.
            # TODO: Writer should be private!
            base.attribute :basis_tax_reduction, Types::Nullable::Float

            # Cancelled If the document is cancelled.
            # TODO: Writer should be private!
            base.attribute :cancelled, Types::Nullable::Boolean

            # City City for the document address.
            base.attribute :city, Types::Nullable::String

            # Comments Comments of the document
            base.attribute :comments, Types::Nullable::String

            # ContributionPercent Document contribution in percent.
            # TODO: Writer should be private!
            base.attribute :contribution_percent, Types::Nullable::Float

            # ContributionValue Document contribution in amount.
            # TODO: Writer should be private!
            base.attribute :contribution_value, Types::Nullable::Float

            # Country Country for the document address.
            base.attribute :country, Types::Nullable::String

            # CostCenter Code of the cost center.
            base.attribute :cost_center, Types::Nullable::String

            # Currency Code of the currency.
            base.attribute :currency, Types::Nullable::String

            # CurrencyRate Currency rate used for the document. 16 digits
            base.attribute :currency_rate, Types::Nullable::Float

            # CurrencyUnit Currency unit used for the document. 16 digits
            base.attribute :currency_unit, Types::Nullable::Float

            # CustomerName Name of the customer. 1024 characters
            base.attribute :customer_name, Types::Nullable::String

            # CustomerNumber Customer number of the customer. Required
            base.attribute :customer_number, Types::Nullable::String

            # DeliveryAddress1 Document delivery address 1.
            base.attribute :delivery_address1, Types::Nullable::String

            # DeliveryAddress2 Document delivery address 2.
            base.attribute :delivery_address2, Types::Nullable::String

            # DeliveryCity City for the document delivery address.
            base.attribute :delivery_city, Types::Nullable::String

            # DeliveryCountry Country for the document delivery address.
            base.attribute :delivery_country, Types::Nullable::String

            # DeliveryDate Date of delivery.
            base.attribute :delivery_date, Types::Nullable::Date

            # DeliveryName  Name of the recipient of the delivery
            base.attribute :delivery_name, Types::Nullable::String

            # DeliveryZipCode ZipCode for the document delivery address.
            base.attribute :delivery_zip_code, Types::Nullable::String

            # DocumentNumber The document number.
            base.attribute :document_number, Types::Nullable::Integer

            # EmailInformation Separete EmailInformation object
            base.attribute :email_information, EmailInformation

            # ExternalInvoiceReference1 External document reference 1. 80 characters
            base.attribute :external_invoice_reference1, Types::Nullable::String

            # ExternalInvoiceReference2 External document reference 2. 80 characters
            base.attribute :external_invoice_reference2, Types::Nullable::String

            # Freight Freight cost of the document. 12 digits (incl. decimals)
            base.attribute :freight, Types::Nullable::Float

            # FreightVAT VAT of the freight cost.
            # TODO: Writer should be private!
            base.attribute :freight_vat, Types::Nullable::Float

            # Gross Gross value of the document
            # TODO: Writer should be private!
            base.attribute :gross, Types::Nullable::Float

            # HouseWork If there is any row of the document marked “house work”.
            # TODO: Writer should be private!
            base.attribute :house_work, Types::Nullable::Boolean

            # Net Net amount
            # TODO: Writer should be private!
            base.attribute :net, Types::Nullable::Float

            # NotCompleted If the document is set as not completed.
            base.attribute :not_completed, Types::Nullable::Boolean

            # OfferReference Reference to the offer, if one exists.
            # TODO: Writer should be private!
            base.attribute :offer_reference, Types::Nullable::Integer

            # OrganisationNumber Organisation number of the customer for the
            # document.
            # TODO: Writer should be private!
            base.attribute :organisation_number, Types::Nullable::String

            # OurReference Our reference. 50 characters
            base.attribute :our_reference, Types::Nullable::String

            # Phone1 Phone number 1 of the customer for the document. 1024 characters
            base.attribute :phone1, Types::Nullable::String

            # Phone2 Phone number 2 of the customer for the document. 1024 characters
            base.attribute :phone2, Types::Nullable::String

            # PriceList Code of the price list.
            base.attribute :price_list, Types::Nullable::String

            # PrintTemplate Print template of the document.
            base.attribute :print_template, Types::Nullable::String

            # Project Code of the project.
            base.attribute :project, Types::Nullable::String

            # Remarks Remarks of the document. 1024 characters
            base.attribute :remarks, Types::Nullable::String

            # RoundOff Round off amount for the document.
            # TODO: Writer should be private!
            base.attribute :round_off, Types::Nullable::Float

            # Sent If the document is printed or sent in any way.
            # TODO: Writer should be private!
            base.attribute :sent, Types::Nullable::Boolean

            # TaxReduction The amount of tax reduction.
            # TODO: Writer should be private!
            base.attribute :tax_reduction, Types::Nullable::Integer

            # TermsOfDelivery Code of the terms of delivery.
            base.attribute :terms_of_delivery, Types::Nullable::String

            # TermsOfPayment Code of the terms of payment.
            base.attribute :terms_of_payment, Types::Nullable::String

            # Total The total amount of the document.
            # TODO: Writer should be private!
            base.attribute :total, Types::Nullable::Float

            # TotalVAT The total VAT amount of the document.
            # TODO: Writer should be private!
            base.attribute :total_vat, Types::Nullable::Float

            # VATIncluded If the price of the document is including VAT.
            base.attribute :vat_included, Types::Nullable::Boolean

            # WayOfDelivery Code of the way of delivery.
            base.attribute :way_of_delivery, Types::Nullable::String

            # YourOrderNumber Your order number. 30 characters
            base.attribute :your_order_number, Types::Nullable::String

            # YourReference Your reference. 50 characters
            base.attribute :your_reference, Types::Nullable::String

            # ZipCode Zip code of the document. 1024 characters
            base.attribute :zip_code, Types::Nullable::String
          end
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
