require "fortnox/api/models/base"
require "fortnox/api/models/document_base"

module Fortnox
  module API
    module Model
      class Invoice < Fortnox::API::Model::Base
        UNIQUE_ID = :document_number
        STUB = { customer_number: '' }.freeze

        DocumentBase.ify( self )

        #UrlTaxReductionList Direct url to the tax reduction for the invoice.
        attribute :url_tax_reduction_list, Types::Nullable::String.with( read_only: true )

        #AccountingMethod Accounting Method.
        attribute :accounting_method, Types::Nullable::String

        #Balance Balance of the invoice.
        attribute :balance, Types::Nullable::Float.with( read_only: true )

        #Booked If the invoice is bookkept.
        attribute :booked, Types::Nullable::Boolean.with( read_only: true )

        #Credit If the invoice is a credit invoice.
        attribute :credit, Types::Nullable::Boolean.with( read_only: true )

        #CreditInvoiceReference Reference to the credit invoice, if one exits.
        attribute :credit_invoice_reference, Types::Nullable::Integer

        #ContractReference Reference to the contract, if one exists.
        attribute :contract_reference, Types::Nullable::Integer.with( read_only: true )

        #DueDate Due date of the invoice.
        attribute :due_date, Types::Nullable::Date

        #EDIInformation Separate EDIInformation object
        attribute :edi_information, Types::EDIInformation

        #EUQuarterlyReport EU Quarterly Report On / Off
        attribute :eu_quarterly_report, Types::Nullable::Boolean

        #InvoiceDate Invoice date.
        attribute :invoice_date, Types::Nullable::Date

        #InvoicePeriodStart Start date of the invoice period.
        attribute :invoice_period_start, Types::Nullable::Date.with( read_only: true )

        #InvoicePeriodEnd End date of the invoice period.
        attribute :invoice_period_end, Types::Nullable::Date.with( read_only: true )

        #InvoiceRows Separate object
        attribute :invoice_rows, Types::Strict::Array.member( Types::InvoiceRow )

        #InvoiceType The type of invoice.
        attribute :invoice_type, Types::Nullable::String

        #Language Language code.
        attribute :language, Types::Nullable::String

        #LastRemindDate Date of last reminder.
        attribute :last_remind_date, Types::Nullable::Date.with( read_only: true )

        #NoxFinans If the invoice is managed by NoxFinans
        attribute :nox_finans, Types::Nullable::Boolean.with( read_only: true )

        #OCR OCR number of the invoice.
        attribute :ocr, Types::Nullable::String

        #OrderReference Reference to the order, if one exists.
        attribute :order_reference, Types::Nullable::Integer.with( read_only: true )

        #Reminders Number of reminders sent to the customer.
        attribute :reminders, Types::Nullable::Integer.with( read_only: true )

        #VoucherNumber Voucher number for the invoice.
        attribute :voucher_number, Types::Nullable::Integer.with( read_only: true )

        #VoucherSeries Voucher series for the invoice.
        attribute :voucher_series, Types::Nullable::String.with( read_only: true )

        #VoucherYear Voucher year for the invoice.
        attribute :voucher_year, Types::Nullable::Integer.with( read_only: true )
      end
    end
  end
end
