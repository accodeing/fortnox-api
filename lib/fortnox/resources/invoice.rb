# frozen_string_literal: true

module Fortnox
  class Invoice < Document
    using RestEasy::Refinements

    configure do
      path "invoices"
      instance_wrapper "Invoice"
      collection_wrapper "Invoices"
    end

    # AccountingMethod Accounting Method.
    attr :accounting_method, Nullable::String

    # Balance Balance of the invoice.
    attr :balance, Nullable::Float, :read_only

    # Booked If the invoice is bookkept.
    attr :booked, Nullable::Boolean, :read_only

    # Credit If the invoice is a credit invoice.
    attr :credit, Nullable::Boolean, :read_only

    # CreditInvoiceReference Reference to the credit invoice, if one exits.
    attr :credit_invoice_reference, Nullable::Integer

    # ContractReference Reference to the contract, if one exists.
    attr :contract_reference, Nullable::Integer, :read_only

    # DueDate Due date of the invoice.
    attr :due_date, Nullable::Date

    # EDIInformation Separate EDIInformation object
    attr :edi_information <=> 'EDIInformation', EDIInformation

    # EUQuarterlyReport EU Quarterly Report On / Off
    attr :eu_quarterly_report <=> 'EUQuarterlyReport', Nullable::Boolean

    # TODO: new attribute
    attr :final_pay_date, String

    # InvoiceDate Invoice date.
    attr :invoice_date, Nullable::Date

    # InvoicePeriodStart Start date of the invoice period.
    attr :invoice_period_start, Nullable::Date, :read_only

    # InvoicePeriodEnd End date of the invoice period.
    attr :invoice_period_end, Nullable::Date, :read_only

    # TODO: This is a new attribute
    attr :invoice_reference, Nullable::Integer

    # InvoiceRows Separate object
    attr :invoice_rows, Strict::Array.of(InvoiceRow)

    # InvoiceType The type of invoice.
    attr :invoice_type, Nullable::String

    # LastRemindDate Date of last reminder.
    attr :last_remind_date, Nullable::Date, :read_only

    # NoxFinans If the invoice is managed by NoxFinans
    attr :nox_finans, Nullable::Boolean, :read_only

    # OCR OCR number of the invoice.
    attr :ocr <=> 'OCR', Nullable::String

    # OrderReference Reference to the order, if one exists.
    attr :order_reference, Nullable::Integer, :read_only

    # TODO: new attribute
    attr :payment_way, String

    # Reminders Number of reminders sent to the customer.
    attr :reminders, Nullable::Integer, :read_only

    # VoucherNumber Voucher number for the invoice.
    attr :voucher_number, Nullable::Integer, :read_only

    # VoucherSeries Voucher series for the invoice.
    attr :voucher_series, Nullable::String, :read_only

    # VoucherYear Voucher year for the invoice.
    attr :voucher_year, Nullable::Integer, :read_only
  end
end
