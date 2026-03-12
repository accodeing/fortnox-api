# frozen_string_literal: true

module Fortnox
  # Shared attributes for Offer, Order and Invoice — the three "document" resources in Fortnox.
  # In the Fortnox implementation these are so close together that they are saved in the same database table.
  # This is never used standalone, only inherited by the respective resources.
  class Document < Fortnox::Resource
    using RestEasy::Refinements

    # Url Direct url to the record.
    attr :url <=> '@url', Nullable::String, :read_only

    # TODO: new attribute
    attr :tax_reduction_list_url <=> '@urlTaxReductionList', Nullable::String, :read_only

    # AdministrationFee The document administration fee.
    attr :administration_fee, Nullable::Float

    # AdministrationFeeVAT VAT of the document administration fee.
    attr :administration_fee_vat <=> "AdministrationFeeVAT", Nullable::Float, :read_only

    # Address1 Document address 1. 1024 characters
    attr :address1, Sized::String[1024]

    # Address2 Document address 2. 1024 characters
    attr :address2, Sized::String[1024]

    # BasisTaxReduction Basis of tax reduction.
    attr :basis_tax_reduction, Nullable::Float, :read_only

    # Cancelled If the document is cancelled.
    attr :cancelled, Nullable::Boolean, :read_only

    # City City for the document address.
    attr :city, Sized::String[1024]

    # Comments Comments of the document
    attr :comments, Sized::String[1024]

    # ContributionPercent Document contribution in percent.
    attr :contribution_percent, Nullable::Float, :read_only

    # ContributionValue Document contribution in amount.
    attr :contribution_value, Nullable::Float, :read_only

    # Country Country for the document address.
    attr :country_code <=> 'Country', Sized::String[2], Parsers::CountryCode

    # CostCenter Code of the cost center.
    attr :cost_center, Nullable::String

    # Currency Code of the currency.
    attr :currency, Currency

    # CurrencyRate Currency rate used for the document
    attr :currency_rate, Nullable::Float

    # CurrencyUnit Currency unit used for the document
    attr :currency_unit, Nullable::Float

    # CustomerName Name of the customer. 1024 characters
    attr :customer_name, Sized::String[1024]

    # CustomerNumber Customer number of the customer. Required
    attr :customer_number, Required::String

    # DeliveryAddress1 Document delivery address 1.
    attr :delivery_address1, Sized::String[1024]

    # DeliveryAddress2 Document delivery address 2.
    attr :delivery_address2, Sized::String[1024]

    # DeliveryCity City for the document delivery address.
    attr :delivery_city, Sized::String[1024]

    # DeliveryCountry Country for the document delivery address.
    attr :delivery_country, Sized::String[2], Parsers::CountryCode

    # DeliveryDate Date of delivery.
    attr :delivery_date, Nullable::Date

    # DeliveryName  Name of the recipient of the delivery
    attr :delivery_name, Sized::String[1024]

    # DeliveryZipCode ZipCode for the document delivery address.
    attr :delivery_zip_code, Sized::String[1024]

    # DocumentNumber The document number.
    key :document_number, Nullable::Integer

    # EmailInformation Separate EmailInformation object
    attr :email_information, EmailInformation

    # ExternalInvoiceReference1 External document reference 1. 80 characters
    attr :external_invoice_reference1, Sized::String[80]

    # ExternalInvoiceReference2 External document reference 2. 80 characters
    attr :external_invoice_reference2, Sized::String[80]

    # Freight Freight cost of the document. 12 digits (incl. decimals)
    attr :freight, Sized::Float[0.0, 99_999_999_999.9]

    # FreightVAT VAT of the freight cost.
    attr :freight_vat <=> 'FreightVAT', Nullable::Float, :read_only

    # Gross Gross value of the document
    attr :gross, Nullable::Float, :read_only

    # HouseWork If there is any row of the document marked "housework".
    attr :housework <=> 'HouseWork', Nullable::Boolean, :read_only

    # TODO: Update comment to something resonable
    attr :labels, Strict::Array.of(Types.Instance(Label)), Parsers::Labels

    # Net Net amount
    attr :net, Nullable::Float, :read_only

    # NotCompleted If the document is set as not completed.
    attr :not_completed, Nullable::Boolean

    # OfferReference Reference to the offer, if one exists.
    attr :offer_reference, Nullable::Integer, :read_only

    # OrganisationNumber Organisation number of the customer for the document.
    attr :organisation_number, Nullable::String, :read_only

    # OurReference Our reference. 50 characters
    attr :our_reference, Sized::String[50]

    # Phone1 Phone number 1 of the customer for the document. 1024 characters
    attr :phone1, Sized::String[1024]

    # Phone2 Phone number 2 of the customer for the document. 1024 characters
    attr :phone2, Sized::String[1024]

    # PriceList Code of the price list.
    attr :price_list, Nullable::String

    # PrintTemplate Print template of the document.
    attr :print_template, Nullable::String

    # Project Code of the project.
    attr :project, Nullable::String

    # Remarks Remarks of the document. 1024 characters
    attr :remarks, Sized::String[1024]

    # RoundOff Round off amount for the document.
    attr :round_off, Nullable::Float, :read_only

    # Sent If the document is printed or sent in any way.
    attr :sent, Nullable::Boolean, :read_only

    # TaxReduction The amount of tax reduction.
    attr :tax_reduction, Nullable::Integer, :read_only

    # TODO: new attribute
    attr :tax_reduction_type, String

    # TermsOfDelivery Code of the terms of delivery.
    attr :terms_of_delivery, Nullable::String

    # TermsOfPayment Code of the terms of payment.
    attr :terms_of_payment, Nullable::String

    # Total The total amount of the document.
    attr :total, Nullable::Float, :read_only

    # TotalVAT The total VAT amount of the document.
    attr :total_vat <=> 'TotalVAT', Nullable::Float, :read_only

    # VATIncluded If the price of the document is including VAT.
    attr :vat_included <=> 'VATIncluded', Nullable::Boolean

    # WayOfDelivery Code of the way of delivery.
    attr :way_of_delivery, Nullable::String

    # YourOrderNumber Your order number. 30 characters
    attr :your_order_number, Sized::String[30]

    # YourReference Your reference. 50 characters
    attr :your_reference, Sized::String[50]

    # ZipCode Zip code of the document. 1024 characters
    attr :zip_code, Sized::String[1024]

    # Language Language code.
    attr :language, Nullable::String

    # TODO: new attribute
    attr :outbound_date, String

    # TODO: new attribute
    attr :time_basis_reference, String

    # TODO: new attribute
    attr :total_to_pay, Nullable::Integer

    # TODO: new attribute
    attr :warehouse_ready, Boolean
  end
end
