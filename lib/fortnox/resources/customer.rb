# frozen_string_literal: true

module Fortnox
  class Customer < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path 'customers'
      instance_wrapper 'Customer'
      collection_wrapper 'Customers'
      scope 'customer'
    end

    # Direct URL to the record.
    attr :url <=> '@url', Coercible::String.optional, :read_only

    # First address of the customer
    attr :address1, Sized::String[1024]

    # Second address of the customer
    attr :address2, Sized::String[1024]

    # City of the customer
    attr :city, Sized::String[1024]

    # Country of the customer
    attr :country, Coercible::String.optional, :read_only

    # Comments
    attr :comments, Sized::String[1024]

    # Currency of the customer
    attr :currency, Currencies

    # Cost center of the customer
    attr :cost_center, Coercible::String.optional

    # Country code of the customer
    attr :country_code, Sized::String[2]

    # Customer number
    key :customer_number, Sized::String[1024]

    # Default delivery types
    attr :default_delivery_types, Structs::DefaultDeliveryTypes, Mappers::Struct.for(Structs::DefaultDeliveryTypes)

    # Default templates
    attr :default_templates, Structs::DefaultTemplates, Mappers::Struct.for(Structs::DefaultTemplates)

    # First delivery address of the customer
    attr :delivery_address1, Sized::String[1024]

    # Second delivery address of the customer
    attr :delivery_address2, Sized::String[1024]

    # Delivery city of the customer
    attr :delivery_city, Sized::String[1024]

    # Delivery country of the customer
    attr :delivery_country, Coercible::String.optional, :read_only

    # Delivery country code of the customer
    attr :delivery_country_code, Sized::String[2]

    # Delivery fax number of the customer
    attr :delivery_fax, Sized::String[1024]

    # Delivery name of the customer
    attr :delivery_name, Sized::String[1024]

    # First delivery phone number of the customer
    attr :delivery_phone1, Sized::String[1024]

    # Second delivery phone number of the customer
    attr :delivery_phone2, Sized::String[1024]

    # Delivery zip code of the customer
    attr :delivery_zip_code, Sized::String[1024]

    # Email address of the customer
    attr :email, Email

    # Invoice email address of the customer
    attr :email_invoice, Email

    # Invoice BCC email address of the customer
    attr :email_invoice_bcc <=> 'EmailInvoiceBCC', Email

    # Invoice CC email address of the customer
    attr :email_invoice_cc <=> 'EmailInvoiceCC', Email

    # Offer email address of the customer
    attr :email_offer, Email

    # Offer BCC email address of the customer
    attr :email_offer_bcc <=> 'EmailOfferBCC', Email

    # Offer CC email address of the customer
    attr :email_offer_cc <=> 'EmailOfferCC', Email

    # Order email address of the customer
    attr :email_order, Email

    # Order BCC email address of the customer
    attr :email_order_bcc <=> 'EmailOrderBCC', Email

    # Order CC email address of the customer
    attr :email_order_cc <=> 'EmailOrderCC', Email

    # Fax number of the customer
    attr :fax, Sized::String[1024]

    # Invoice administration fee, 12 digits (incl. decimals)
    attr :invoice_administration_fee, Sized::Float[0.0, 99_999_999_999.9]

    # Invoice discount, 12 digits (incl. decimals)
    attr :invoice_discount, Sized::Float[0.0, 99_999_999_999.9]

    # Invoice freight fee, 12 digits (incl. decimals)
    attr :invoice_freight, Sized::Float[0.0, 99_999_999_999.9]

    # Invoice remark
    attr :invoice_remark, Sized::String[1024]

    # Name of the customer
    attr :name, Sized::String[1024], :required

    # Organisation number of the customer
    attr :organisation_number, Sized::String[30]

    # Our reference
    attr :our_reference, Sized::String[50]

    # First phone number of the customer
    attr :phone1, Sized::String[1024]

    # Second phone number of the customer
    attr :phone2, Sized::String[1024]

    # Price list of the customer
    attr :price_list, Coercible::String.optional

    # Project of the customer
    attr :project, Coercible::String.optional

    # Sales account of the customer
    attr :sales_account, Types::AccountNumber

    # Show prices with VAT included or not
    attr :show_price_vat_included <=> 'ShowPriceVATIncluded', Bool.optional, Boolean

    # Terms of delivery code
    attr :terms_of_delivery, Coercible::String.optional

    # Terms of payment code
    attr :terms_of_payment, Coercible::String.optional

    # Customer type
    attr :type, CustomerTypes

    # VAT number of the customer
    attr :vat_number <=> 'VATNumber', Coercible::String.optional

    # VAT type of the customer
    attr :vat_type <=> 'VATType', VATTypes

    # Visit address of the customer
    attr :visiting_address, Sized::String[128]

    # Visit city of the customer
    attr :visiting_city, Sized::String[128]

    # Visit country of the customer
    attr :visiting_country, Coercible::String.optional, :read_only

    # Visiting country code
    attr :visiting_country_code, Sized::String[2]

    # Visit zip code of the customer
    attr :visiting_zip_code, Sized::String[10]

    # Way of delivery code
    attr :way_of_delivery, Coercible::String.optional

    # Your reference
    attr :your_reference, Sized::String[50]

    # Zip code of the customer
    attr :zip_code, Sized::String[10]

    # Active If the customer is active.
    attr :active, Bool.optional, Boolean

    # Phone number of the customer. Only present in collection responses.
    attr :phone, Coercible::String.optional

    # External reference
    attr :external_reference, Sized::String[1024]

    # GLN Global Location Number
    attr :gln <=> 'GLN', Sized::String[13]

    # GLNDelivery Global Location Number for delivery
    attr :gln_delivery <=> 'GLNDelivery', Sized::String[13]

    # WWW Website URL
    attr :www <=> 'WWW', Sized::String[128]
  end
end
