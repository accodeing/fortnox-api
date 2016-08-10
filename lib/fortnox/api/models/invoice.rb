require "fortnox/api/models/second_base"
require "fortnox/api/models/document_base"
require "fortnox/api/models/edi_information"
require "fortnox/api/models/invoice_row"

module Fortnox
  module API
    module Model
      class Invoice < Fortnox::API::Model::SecondBase
        include DocumentBase

        #UrlTaxReductionList Direct url to the tax reduction for the invoice.
        #TODO: Writer should be private!
        attribute :url_tax_reduction_list, Types::Nullable::String

        #AccountingMethod Accounting Method.
        attribute :accounting_method, Types::Nullable::String

        #Balance Balance of the invoice.
        #TODO: Writer should be private!
        attribute :balance, Types::Nullable::Float

        #Booked If the invoice is bookkept.
        #TODO: Writer should be private!
        attribute :booked, Types::Nullable::Boolean

        #Credit If the invoice is a credit invoice.
        #TODO: Writer should be private!
        attribute :credit, Types::Nullable::Boolean

        #CreditInvoiceReference Reference to the credit invoice, if one exits.
        attribute :credit_invoice_reference, Types::Nullable::Integer

        #ContractReference Reference to the contract, if one exists.
        #TODO: Writer should be private!
        attribute :contract_reference, Types::Nullable::Integer

        #DueDate Due date of the invoice.
        attribute :due_date, Types::Nullable::Date

        #EDIInformation Separate EDIInformation object
        attribute :edi_information, EDIInformation

        #EUQuarterlyReport EU Quarterly Report On / Off
        attribute :eu_quarterly_report, Types::Nullable::Boolean

        #InvoiceDate Invoice date.
        attribute :invoice_date, Types::Nullable::Date

        #InvoicePeriodStart Start date of the invoice period.
        #TODO: Writer should be private!
        attribute :invoice_period_start, Types::Nullable::Date

        #InvoicePeriodEnd End date of the invoice period.
        #TODO: Writer should be private!
        attribute :invoice_period_end, Types::Nullable::Date

        #InvoiceRows Separate object
        attribute :invoice_rows, Types::Strict::Array.member( InvoiceRow )

        #InvoiceType The type of invoice.
        attribute :invoice_type, Types::Nullable::String

        #Language Language code.
        attribute :language, Types::Nullable::String

        #LastRemindDate Date of last reminder.
        #TODO: Writer should be private!
        attribute :last_remind_date, Types::Nullable::Date

        #NoxFinans If the invoice is managed by NoxFinans
        #TODO: Writer should be private!
        attribute :nox_finans, Types::Nullable::Boolean

        #OCR OCR number of the invoice.
        attribute :ocr, Types::Nullable::String

        #OrderReference Reference to the order, if one exists.
        #TODO: Writer should be private!
        attribute :order_reference, Types::Nullable::Integer

        #Reminders Number of reminders sent to the customer.
        #TODO: Writer should be private!
        attribute :reminders, Types::Nullable::Integer

        #VoucherNumber Voucher number for the invoice.
        #TODO: Writer should be private!
        attribute :voucher_number, Types::Nullable::Integer

        #VoucherSeries Voucher series for the invoice.
        #TODO: Writer should be private!
        attribute :voucher_series, Types::Nullable::String

        #VoucherYear Voucher year for the invoice.
        #TODO: Writer should be private!
        attribute :voucher_year, Types::Nullable::Integer
      end
    end
  end
end
