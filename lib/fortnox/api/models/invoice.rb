require "fortnox/api/models/document_base"
require "fortnox/api/models/edi_information"
require "fortnox/api/models/invoice_row"

module Fortnox
  module API
    module Model
      class Invoice < Fortnox::API::Model::Base
        include DocumentBase

        #UrlTaxReductionList Direct url to the tax reduction for the invoice.
        #TODO: Writer should be private!
        attribute :url_tax_reduction_list, String

        #AccountingMethod Accounting Method.
        attribute :accounting_method, String

        #Balance Balance of the invoice.
        #TODO: Writer should be private!
        attribute :balance, Float

        #Booked If the invoice is bookkept.
        #TODO: Writer should be private!
        attribute :booked, Boolean

        #Credit If the invoice is a credit invoice.
        #TODO: Writer should be private!
        attribute :credit, Boolean

        #CreditInvoiceReference Reference to the credit invoice, if one exits.
        attribute :credit_invoice_reference, Integer

        #ContractReference Reference to the contract, if one exists.
        #TODO: Writer should be private!
        attribute :contract_reference, Integer

        #DueDate Due date of the invoice.
        attribute :due_date, Date

        #EDIInformation Separate EDIInformation object
        attribute :edi_information, EDIInformation

        #EUQuarterlyReport EU Quarterly Report On / Off
        attribute :eu_quarterly_report, Boolean

        #InvoiceDate Invoice date.
        attribute :invoice_date, Date

        #InvoicePeriodStart Start date of the invoice period.
        #TODO: Writer should be private!
        attribute :invoice_period_start, Date

        #InvoicePeriodEnd End date of the invoice period.
        #TODO: Writer should be private!
        attribute :invoice_period_end, Date

        #InvoiceRows Separate object
        attribute :invoice_rows, Array[InvoiceRow]

        #InvoiceType The type of invoice.
        attribute :invoice_type, String

        #Language Language code.
        attribute :language, String

        #LastRemindDate Date of last reminder.
        #TODO: Writer should be private!
        attribute :last_remind_date, Date

        #NoxFinans If the invoice is managed by NoxFinans
        #TODO: Writer should be private!
        attribute :nox_finans, Boolean

        #OCR OCR number of the invoice.
        attribute :ocr, String

        #OrderReference Reference to the order, if one exists.
        #TODO: Writer should be private!
        attribute :order_reference, Integer

        #Reminders Number of reminders sent to the customer.
        #TODO: Writer should be private!
        attribute :reminders, Integer

        #VoucherNumber Voucher number for the invoice.
        #TODO: Writer should be private!
        attribute :voucher_number, Integer

        #VoucherSeries Voucher series for the invoice.
        #TODO: Writer should be private!
        attribute :voucher_series, String

        #VoucherYear Voucher year for the invoice.
        #TODO: Writer should be private!
        attribute :voucher_year, Integer
      end
    end
  end
end
