# frozen_string_literal: true

module Fortnox
  # Shared attributes for Offer, Order and Invoice — the three "document" resources in Fortnox.
  # In the Fortnox implementation these are so close together that they are saved in the same database table.
  # This is never used standalone, only inherited by the respective resources.
  class Document < Fortnox::Resource
    using RestEasy::Refinements

    # Url Direct url to the record.
    attr :url <=> '@url', UnsizedString, :read_only

    # @urlTaxReductionList Direct URL to the tax reduction list.
    attr :tax_reduction_list_url <=> '@urlTaxReductionList', UnsizedString, :read_only

    # AdministrationFee The document administration fee.
    attr :administration_fee, UnsizedFloat

    # AdministrationFeeVAT VAT of the document administration fee.
    attr :administration_fee_vat <=> 'AdministrationFeeVAT', UnsizedFloat, :read_only

    # Address1 Document address 1.
    attr :address1, Sized::String[1024]

    # Address2 Document address 2
    attr :address2, Sized::String[1024]

    # BasisTaxReduction Basis of tax reduction.
    attr :basis_tax_reduction, UnsizedFloat, :read_only

    # Cancelled If the document is cancelled.
    attr :cancelled, Bool.optional, :read_only, Boolean

    # City City for the document address.
    attr :city, Sized::String[1024]

    # Comments Comments of the document
    attr :comments, Sized::String[1024]

    # ContributionPercent Document contribution in percent.
    attr :contribution_percent, UnsizedFloat, :read_only

    # ContributionValue Document contribution in amount.
    attr :contribution_value, UnsizedFloat, :read_only

    # Country Country for the document address.
    attr :country_code <=> 'Country', Sized::String[2], Mappers::CountryCode

    # CostCenter Code of the cost center.
    attr :cost_center, UnsizedString

    # Currency Code of the currency.
    attr :currency, Currencies

    # CurrencyRate Currency rate used for the document
    attr :currency_rate, UnsizedFloat

    # CurrencyUnit Currency unit used for the document
    attr :currency_unit, UnsizedFloat

    # CustomerName Name of the customer
    attr :customer_name, Sized::String[1024]

    # CustomerNumber Customer number of the customer.
    attr :customer_number, Strict::String, :required

    # DeliveryAddress1 Document delivery address 1.
    attr :delivery_address1, Sized::String[1024]

    # DeliveryAddress2 Document delivery address 2.
    attr :delivery_address2, Sized::String[1024]

    # DeliveryCity City for the document delivery address.
    attr :delivery_city, Sized::String[1024]

    # DeliveryCountry Country for the document delivery address.
    attr :delivery_country, Sized::String[2], Mappers::CountryCode

    # DeliveryDate Date of delivery.
    attr :delivery_date, Date.optional, Mappers::Date

    # DeliveryName Name of the recipient of the delivery
    attr :delivery_name, Sized::String[1024]

    # DeliveryZipCode ZipCode for the document delivery address.
    attr :delivery_zip_code, Sized::String[1024]

    # DocumentNumber The document number.
    key :document_number, UnsizedInteger

    # EmailInformation Separate EmailInformation object
    attr :email_information, Structs::EmailInformation, Mappers::EmailInformation

    # ExternalInvoiceReference1 External document reference 1
    attr :external_invoice_reference1, Sized::String[80]

    # ExternalInvoiceReference2 External document reference 2
    attr :external_invoice_reference2, Sized::String[80]

    # Freight Freight cost of the document. 12 digits (incl. decimals)
    attr :freight, Sized::Float[0.0, 99_999_999_999.9]

    # FreightVAT VAT of the freight cost.
    attr :freight_vat <=> 'FreightVAT', UnsizedFloat, :read_only

    # Gross Gross value of the document
    attr :gross, UnsizedFloat, :read_only

    # HouseWork If there is any row of the document marked "housework".
    attr :housework <=> 'HouseWork', Bool.optional, :read_only, Boolean

    # Labels attached to the document.
    attr :labels, Strict::Array.of(Types.Instance(Label)), Mappers::LabelReferences

    # Net Net amount
    attr :net, UnsizedFloat, :read_only

    # NotCompleted If the document is set as not completed.
    attr :not_completed, Bool.optional, Boolean

    # OfferReference Reference to the offer, if one exists.
    attr :offer_reference, UnsizedInteger, :read_only

    # OrganisationNumber Organisation number of the customer for the document.
    attr :organisation_number, UnsizedString, :read_only

    # OurReference Our reference
    attr :our_reference, Sized::String[50]

    # Phone1 Phone number 1 of the customer for the document
    attr :phone1, Sized::String[1024]

    # Phone2 Phone number 2 of the customer for the document
    attr :phone2, Sized::String[1024]

    # PriceList Code of the price list.
    attr :price_list, UnsizedString

    # PrintTemplate Print template of the document.
    attr :print_template, UnsizedString

    # Project Code of the project.
    attr :project, UnsizedString

    # Remarks Remarks of the document
    attr :remarks, Sized::String[1024]

    # RoundOff Round off amount for the document.
    attr :round_off, UnsizedFloat, :read_only

    # Sent If the document is printed or sent in any way.
    attr :sent, Bool.optional, :read_only, Boolean

    # TaxReduction The amount of tax reduction.
    attr :tax_reduction, UnsizedInteger, :read_only

    # TaxReductionType Type of tax reduction.
    attr :tax_reduction_type, TaxReductionTypes

    # TermsOfDelivery Code of the terms of delivery.
    attr :terms_of_delivery, UnsizedString

    # TermsOfPayment Code of the terms of payment.
    attr :terms_of_payment, UnsizedString

    # Total The total amount of the document.
    attr :total, UnsizedFloat, :read_only

    # TotalVAT The total VAT amount of the document.
    attr :total_vat <=> 'TotalVAT', UnsizedFloat, :read_only

    # VATIncluded If the price of the document is including VAT.
    attr :vat_included <=> 'VATIncluded', Bool.optional, Boolean

    # WayOfDelivery Code of the way of delivery.
    attr :way_of_delivery, UnsizedString

    # YourOrderNumber Your order number
    attr :your_order_number, Sized::String[75]

    # YourReference Your reference
    attr :your_reference, Sized::String[50]

    # ZipCode Zip code of the document
    attr :zip_code, Sized::String[1024]

    # Language Language code.
    attr :language, UnsizedString

    # OutboundDate Date of outbound delivery.
    attr :outbound_date, Date.optional, Mappers::Date

    # TimeBasisReference Reference to time basis.
    attr :time_basis_reference, UnsizedInteger, :read_only

    # TotalToPay Total amount to pay.
    attr :total_to_pay, UnsizedFloat, :read_only

    # WarehouseReady If the document is warehouse ready.
    attr :warehouse_ready, Bool.optional, :read_only, Boolean
  end
end
