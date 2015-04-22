require "fortnox/api/entities/base"

module Fortnox
  module API
    module Entities
      module Customer
        class Entity < Fortnox::API::Entities::Base

          #Url	Direct URL to the record
          attribute :url, String, writer: :private

          #Address1	First address of the customer
          attribute :address1, String

          #Address2	Second address of the customer
          attribute :address2, String

          #City	City of the customer
          attribute :city, String

          #Country	Country of the customer
          attribute :country, String

          #Comments	Comments
          attribute :comments, String

          #Currency	Currency of the customer, 3 letters
          attribute :currency, String

          #CostCenter	Cost center of the customer, Cost center in Fortnox
          attribute :cost_center, String

          #CountryCode	Country code of the customer, 2 letters
          attribute :country_code, String

          #CustomerNumber	Customer number
          attribute :customer_number, String

          #DeliveryAddress1	First delivery address of the customer
          attribute :delivery_address1, String

          #DeliveryAddress2	Second delivery address of the customer
          attribute :delivery_address2, String

          #DeliveryCity	Delivery city of the customer
          attribute :delivery_city, String

          #DeliveryCountry	Delivery country of the customer
          attribute :delivery_country, String

          #DeliveryCountryCode	Delivery country code of the customer
          attribute :delivery_country_code, String

          #DeliveryFax	Delivery fax number of the customer
          attribute :delivery_fax, String

          #DeliveryName	Delivery name of the customer
          attribute :delivery_name, String

          #DeliveryPhone1	First delivery phone number of the customer
          attribute :delivery_phone1, String

          #DeliveryPhone2	Second delivery phone number of the customer
          attribute :delivery_phone2, String

          #DeliveryZipCode	Delivery zip code of the customer
          attribute :delivery_zip_code, String

          #Email	Email address of the customer
          attribute :email, String

          #EmailInvoice	Invoice email address of the customer
          attribute :email_invoice, String

          #EmailInvoiceBCC	Invoice BCC email address of the customer
          attribute :email_invoice_bcc, String

          #EmailInvoiceCC	Invoice CC email address of the customer
          attribute :email_invoice_cc, String

          #EmailOffer	Offer email address of the customer
          attribute :email_offer, String

          #EmailOfferBCC	Offer BCC email address of the customer
          attribute :email_offer_bcc, String

          #EmailOfferCC	Offer CC email address of the customer
          attribute :email_offer_cc, String

          #EmailOrder	Order email address of the customer
          attribute :email_order, String

          #EmailOrderBCC	Order BCC email address of the customer
          attribute :email_order_bcc, String

          #EmailOrderCC	Order CC email address of the customer
          attribute :email_order_cc, String

          #Fax	Fax number of the customer
          attribute :fax, String

          #InvoiceAdministrationFee  Invoice administration fee of the customer
          attribute :invoice_administration_fee, Float

          #InvoiceDiscount	Invoice discount of the customer
          attribute :invoice_discount, Float

          #InvoiceFreight	Invoice freight fee of the customer
          attribute :invoice_freight, Float

          #InvoiceRemark	Invoice remark of the customer
          attribute :invoice_remark, String

          #Name	Name of the customer
          attribute :name, String

          #OrganisationNumber	Organisation number of the customer
          attribute :organisation_number, String

          #OurReference	Our reference of the customer
          attribute :our_reference, String

          #Phone1	First phone number of the customer
          attribute :phone1, String

          #Phone2	Second phone number of the customer
          attribute :phone2, String

          #PriceList	Price list of the customer, Price list in Fortnox
          attribute :price_list, String

          #Project	Project of the customer, Project in Fortnox
          attribute :project, Integer

          #SalesAccount	Sales account of the customer, 4 digits
          attribute :sales_account, Integer

          #ShowPriceVATIncluded	Show prices with VAT included or not
          attribute :show_price_vat_included, Boolean

          #TermsOfDeliveryCode	Terms of delivery code of the customer
          attribute :terms_of_delivery_code, String

          #TermsOfPaymentCode	Terms of payment code of the customer
          attribute :terms_of_payment_code, String

          #Type	Customer type, PRIVATE / COMPANY
          attribute :type, String

          #VATNumber	VAT number of the customer
          attribute :vat_number, String

          #VATType	VAT type of the customer, SEVAT / SEREVERSEDVAT / EUREVERSEDVAT / EUVAT / EXPORT
          attribute :vat_type, String

          #VisitAddress	Visit address of the customer
          attribute :visit_address, String

          #VisitCity	Visit city of the customer
          attribute :visit_city, String

          #VisitCountry	Visit country of the customer
          attribute :visit_country, String

          #VisitZipCode	Visit zip code of the customer
          attribute :visit_zip_code, String

          #WayOfDeliveryCode	Way of delivery code of the customer
          attribute :way_of_delivery_code, String

          #YourReference	Your reference of the customer
          attribute :your_reference, String

          #ZipCode	Zip code of the customer
          attribute :zip_code, String

        end
      end
    end
  end
end
