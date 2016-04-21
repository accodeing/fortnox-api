require "fortnox/api/models/base"
require "fortnox/api/models/email_information"

module Fortnox
  module API
    module Model
      module DocumentBase
        #rubocop:disable Metrics/MethodLength
        def self.included(base)
          # Url Direct url to the record.
          base.attribute :url, String, writer: :private

          # AdministrationFee The document administration fee. 12 digits (incl. decimals)
          base.attribute :administration_fee, Float

          # AdministrationFeeVAT VAT of the document administration fee.
          base.attribute :administration_fee_vat, Float, writer: :private

          # Address1 Document address 1. 1024 characters
          base.attribute :address1, String

          # Address2 Document address 2. 1024 characters
          base.attribute :address2, String

          # BasisTaxReduction Basis of tax reduction.
          base.attribute :basis_tax_reduction, Float, writer: :private

          # Cancelled If the document is cancelled.
          base.attribute :cancelled, base::Boolean, writer: :private

          # City City for the document address.
          base.attribute :city, String

          # Comments Comments of the document
          base.attribute :comments, String

          # ContributionPercent Document contribution in percent.
          base.attribute :contribution_percent, Float, writer: :private

          # ContributionValue Document contribution in amount.
          base.attribute :contribution_value, Float, writer: :private

          # Country Country for the document address.
          base.attribute :country, String

          # CostCenter Code of the cost center.
          base.attribute :cost_center, String

          # Currency Code of the currency.
          base.attribute :currency, String

          # CurrencyRate Currency rate used for the document. 16 digits
          base.attribute :currency_rate, Float

          # CurrencyUnit Currency unit used for the document. 16 digits
          base.attribute :currency_unit, Float

          # CustomerName Name of the customer. 1024 characters
          base.attribute :customer_name, String

          # CustomerNumber Customer number of the customer. Required
          base.attribute :customer_number, String

          # DeliveryAddress1 Document delivery address 1.
          base.attribute :delivery_address1, String

          # DeliveryAddress2 Document delivery address 2.
          base.attribute :delivery_address2, String

          # DeliveryCity City for the document delivery address.
          base.attribute :delivery_city, String

          # DeliveryCountry Country for the document delivery address.
          base.attribute :delivery_country, String

          # DeliveryDate Date of delivery.
          base.attribute :delivery_date, Date

          # DeliveryName  Name of the recipient of the delivery
          base.attribute :delivery_name, String

          # DeliveryZipCode ZipCode for the document delivery address.
          base.attribute :delivery_zip_code, String

          # DocumentNumber The document number.
          base.attribute :document_number, Integer

          # EmailInformation Separete EmailInformation object
          base.attribute :email_information, EmailInformation

          # ExternalInvoiceReference1 External document reference 1. 80 characters
          base.attribute :external_invoice_reference1, String

          # ExternalInvoiceReference2 External document reference 2. 80 characters
          base.attribute :external_invoice_reference2, String

          # Freight Freight cost of the document. 12 digits (incl. decimals)
          base.attribute :freight, Float

          # FreightVAT VAT of the freight cost.
          base.attribute :freight_vat, Float, writer: :private

          # Gross Gross value of the document
          base.attribute :gross, Float, writer: :private

          # HouseWork If there is any row of the document marked “house work”.
          base.attribute :house_work, base::Boolean, writer: :private

          # Net Net amount
          base.attribute :net, Float, writer: :private

          # NotCompleted If the document is set as not completed.
          base.attribute :not_completed, base::Boolean

          # OfferReference Reference to the offer, if one exists.
          base.attribute :offer_reference, Integer, writer: :private

          # OrganisationNumber Organisation number of the customer for the
          # document.
          base.attribute :organisation_number, String, writer: :private

          # OurReference Our reference. 50 characters
          base.attribute :our_reference, String

          # Phone1 Phone number 1 of the customer for the document. 1024 characters
          base.attribute :phone1, String

          # Phone2 Phone number 2 of the customer for the document. 1024 characters
          base.attribute :phone2, String

          # PriceList Code of the price list.
          base.attribute :price_list, String

          # PrintTemplate Print template of the document.
          base.attribute :print_template, String

          # Project Code of the project.
          base.attribute :project, String

          # Remarks Remarks of the document. 1024 characters
          base.attribute :remarks, String

          # RoundOff Round off amount for the document.
          base.attribute :round_off, Float, writer: :private

          # Sent If the document is printed or sent in any way.
          base.attribute :sent, base::Boolean, writer: :private

          # TaxReduction The amount of tax reduction.
          base.attribute :tax_reduction, Integer, writer: :private

          # TermsOfDelivery Code of the terms of delivery.
          base.attribute :terms_of_delivery, String

          # TermsOfPayment Code of the terms of payment.
          base.attribute :terms_of_payment, String

          # Total The total amount of the document.
          base.attribute :total, Float, writer: :private

          # TotalVAT The total VAT amount of the document.
          base.attribute :total_vat, Float, writer: :private

          # VATIncluded If the price of the document is including VAT.
          base.attribute :vat_included, base::Boolean

          # WayOfDelivery Code of the way of delivery.
          base.attribute :way_of_delivery, String

          # YourOrderNumber Your order number. 30 characters
          base.attribute :your_order_number, String

          # YourReference Your reference. 50 characters
          base.attribute :your_reference, String

          # ZipCode Zip code of the document. 1024 characters
          base.attribute :zip_code, String
        end
        #rubocop:enable Metrics/MethodLength
      end
    end
  end
end
