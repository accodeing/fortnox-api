# frozen_string_literal: true

module Fortnox
  class Customer < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path 'customers'
      instance_wrapper 'Customer'
      collection_wrapper 'Customers'
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', String.optional, :read_only

    # Address1 First address of the customer
    attr :address1, Sized::String[1024]

    # Address2 Second address of the customer
    attr :address2, Sized::String[1024]

    # City City of the customer
    attr :city, Sized::String[1024]

    # Country Country of the customer. Read-only.
    attr :country, String.optional, :read_only

    # Comments Comments.
    attr :comments, Sized::String[1024]

    # Currency Currency of the customer, 3 letters
    attr :currency, Currencies

    # CostCenter Cost center of the customer
    attr :cost_center, String.optional

    # CountryCode Country code of the customer, 2 letters
    attr :country_code, Sized::String[2]

    # CustomerNumber Customer number
    key :customer_number, Sized::String[1024]

    # DefaultDeliveryTypes
    attr :default_delivery_types, Structs::DefaultDeliveryTypes, Mappers::Struct.for(Structs::DefaultDeliveryTypes)

    # DefaultTemplates
    attr :default_templates, Structs::DefaultTemplates, Mappers::Struct.for(Structs::DefaultTemplates)

    # DeliveryAddress1 First delivery address of the customer
    attr :delivery_address1, Sized::String[1024]

    # DeliveryAddress2 Second delivery address of the customer
    attr :delivery_address2, Sized::String[1024]

    # DeliveryCity Delivery city of the customer
    attr :delivery_city, Sized::String[1024]

    # DeliveryCountry Delivery country of the customer. Read-only.
    attr :delivery_country, String.optional, :read_only

    # DeliveryCountryCode Delivery country code of the customer, 2 letters
    attr :delivery_country_code, Sized::String[2]

    # DeliveryFax Delivery fax number of the customer
    attr :delivery_fax, Sized::String[1024]

    # DeliveryName Delivery name of the customer
    attr :delivery_name, Sized::String[1024]

    # DeliveryPhone1 First delivery phone number of the customer
    attr :delivery_phone1, Sized::String[1024]

    # DeliveryPhone2 Second delivery phone number of the customer
    attr :delivery_phone2, Sized::String[1024]

    # DeliveryZipCode Delivery zip code of the customer.
    attr :delivery_zip_code, Sized::String[1024]

    # Email Email address of the customer. 1024 characters
    attr :email, Email

    # EmailInvoice Invoice email address of the customer. 1024 characters
    attr :email_invoice, Email

    # EmailInvoiceBCC Invoice BCC email address of the customer. 1024 characters
    attr :email_invoice_bcc <=> 'EmailInvoiceBCC', Email

    # EmailInvoiceCC Invoice CC email address of the customer. 1024 characters
    attr :email_invoice_cc <=> 'EmailInvoiceCC', Email

    # EmailOffer Offer email address of the customer. 1024 characters
    attr :email_offer, Email

    # EmailOfferBCC Offer BCC email address of the customer. 1024 characters
    attr :email_offer_bcc <=> 'EmailOfferBCC', Email

    # EmailOfferCC Offer CC email address of the customer. 1024 characters
    attr :email_offer_cc <=> 'EmailOfferCC', Email

    # EmailOrder Order email address of the customer. 1024 characters
    attr :email_order, Email

    # EmailOrderBCC Order BCC email address of the customer. 1024 characters
    attr :email_order_bcc <=> 'EmailOrderBCC', Email

    # EmailOrderCC Order CC email address of the customer. 1024 characters
    attr :email_order_cc <=> 'EmailOrderCC', Email

    # Fax Fax number of the customer
    attr :fax, Sized::String[1024]

    # InvoiceAdministrationFee Invoice administration fee of the customer, 12 digits (incl. decimals).
    attr :invoice_administration_fee, Sized::Float[0.0, 99_999_999_999.9]

    # InvoiceDiscount Invoice discount of the customer, 12 digits (incl. decimals)
    attr :invoice_discount, Sized::Float[0.0, 99_999_999_999.9]

    # InvoiceFreight Invoice freight fee of the customer, 12 digits (incl. decimals)
    attr :invoice_freight, Sized::Float[0.0, 99_999_999_999.9]

    # InvoiceRemark Invoice remark of the customer
    attr :invoice_remark, Sized::String[1024]

    # Name Name of the customer
    attr :name, Sized::String[1024], :required

    # OrganisationNumber Organisation number of the customer
    attr :organisation_number, Sized::String[30]

    # OurReference Our reference of the customer
    attr :our_reference, Sized::String[50]

    # Phone1 First phone number of the customer
    attr :phone1, Sized::String[1024]

    # Phone2 Second phone number of the customer
    attr :phone2, Sized::String[1024]

    # PriceList Price list of the customer
    attr :price_list, String.optional

    # Project Project of the customer
    attr :project, String.optional

    # SalesAccount Sales account of the customer
    attr :sales_account, AccountNumber

    # ShowPriceVATIncluded Show prices with VAT included or not
    attr :show_price_vat_included <=> 'ShowPriceVATIncluded', Boolean.optional

    # TermsOfDelivery Terms of delivery code of the customer
    attr :terms_of_delivery, String.optional

    # TermsOfPayment Terms of payment code of the customer
    attr :terms_of_payment, String.optional

    # Type Customer type, PRIVATE / COMPANY
    attr :type, CustomerTypes

    # VATNumber VAT number of the customer
    attr :vat_number <=> 'VATNumber', String.optional

    # VATType VAT type of the customer
    attr :vat_type <=> 'VATType', VATTypes

    # VisitingAddress Visit address of the customer
    attr :visiting_address, Sized::String[128]

    # VisitingCity Visit city of the customer
    attr :visiting_city, Sized::String[128]

    # VisitingCountry Visit country of the customer, read-only
    attr :visiting_country, String.optional, :read_only

    # VisitingCountryCode Code of the visiting country for the customer, 2 letters
    attr :visiting_country_code, Sized::String[2]

    # VisitingZipCode Visit zip code of the customer
    attr :visiting_zip_code, Sized::String[10]

    # WayOfDelivery Way of delivery code of the customer
    attr :way_of_delivery, String.optional

    # YourReference Your reference of the customer
    attr :your_reference, Sized::String[50]

    # ZipCode Zip code of the customer
    attr :zip_code, Sized::String[10]

    # Active If the customer is active.
    attr :active, Boolean.optional

    # Phone Phone number of the customer. Only present in collection responses.
    attr :phone, String.optional

    # ExternalReference External reference
    attr :external_reference, Sized::String[1024]

    # GLN Global Location Number
    attr :gln <=> 'GLN', Sized::String[13]

    # GLNDelivery Global Location Number for delivery
    attr :gln_delivery <=> 'GLNDelivery', Sized::String[13]

    # WWW Website URL
    attr :www <=> 'WWW', Sized::String[128]
  end
end
