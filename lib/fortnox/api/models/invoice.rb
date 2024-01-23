# frozen_string_literal: true

require_relative 'base'
require_relative 'document'

module Fortnox
  module API
    module Model
      class Invoice < Document
        UNIQUE_ID = :document_number
        STUB = { customer_number: '' }.freeze

        # UrlTaxReductionList Direct url to the tax reduction for the invoice.
        attribute :url_tax_reduction_list, Types::Nullable::String.is(:read_only)

        # AccountingMethod Accounting Method.
        attribute :accounting_method, Types::Nullable::String

        # Balance Balance of the invoice.
        attribute :balance, Types::Nullable::Float.is(:read_only)

        # Booked If the invoice is bookkept.
        attribute :booked, Types::Nullable::Boolean.is(:read_only)

        # Credit If the invoice is a credit invoice.
        attribute :credit, Types::Nullable::Boolean.is(:read_only)

        # CreditInvoiceReference Reference to the credit invoice, if one exits.
        attribute :credit_invoice_reference, Types::Nullable::Integer

        # ContractReference Reference to the contract, if one exists.
        attribute :contract_reference, Types::Nullable::Integer.is(:read_only)

        # DueDate Due date of the invoice.
        attribute :due_date, Types::Nullable::Date

        # EDIInformation Separate EDIInformation object
        attribute :edi_information, Types::EDIInformation

        # EUQuarterlyReport EU Quarterly Report On / Off
        attribute :eu_quarterly_report, Types::Nullable::Boolean

        # InvoiceDate Invoice date.
        attribute :invoice_date, Types::Nullable::Date

        # InvoicePeriodStart Start date of the invoice period.
        attribute :invoice_period_start, Types::Nullable::Date.is(:read_only)

        # InvoicePeriodEnd End date of the invoice period.
        attribute :invoice_period_end, Types::Nullable::Date.is(:read_only)

        # InvoiceRows Separate object
        attribute :invoice_rows, Types::Strict::Array.of(Types::InvoiceRow)

        # InvoiceType The type of invoice.
        attribute :invoice_type, Types::Nullable::String

        # Language Language code.
        attribute :language, Types::Nullable::String

        # LastRemindDate Date of last reminder.
        attribute :last_remind_date, Types::Nullable::Date.is(:read_only)

        # NoxFinans If the invoice is managed by NoxFinans
        attribute :nox_finans, Types::Nullable::Boolean.is(:read_only)

        # OCR OCR number of the invoice.
        attribute :ocr, Types::Nullable::String

        # OrderReference Reference to the order, if one exists.
        attribute :order_reference, Types::Nullable::Integer.is(:read_only)

        # Reminders Number of reminders sent to the customer.
        attribute :reminders, Types::Nullable::Integer.is(:read_only)

        # VoucherNumber Voucher number for the invoice.
        attribute :voucher_number, Types::Nullable::Integer.is(:read_only)

        # VoucherSeries Voucher series for the invoice.
        attribute :voucher_series, Types::Nullable::String.is(:read_only)

        # VoucherYear Voucher year for the invoice.
        attribute :voucher_year, Types::Nullable::Integer.is(:read_only)
      end
    end
  end
end
