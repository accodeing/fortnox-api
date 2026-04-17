# frozen_string_literal: true

module Fortnox
  class Invoice < Document
    using RestEasy::Refinements

    configure do
      path 'invoices'
      instance_wrapper 'Invoice'
      collection_wrapper 'Invoices'
    end

    # AccountingMethod Accounting Method.
    attr :accounting_method, Coercible::String.optional

    # Balance Balance of the invoice.
    attr :balance, Coercible::Float.optional, :read_only

    # Booked If the invoice is bookkept.
    attr :booked, Bool.optional, :read_only, Boolean

    # Credit If the invoice is a credit invoice.
    attr :credit, Bool.optional, :read_only, Boolean

    # CreditInvoiceReference Reference to the credit invoice, if one exits.
    attr :credit_invoice_reference, Coercible::Integer.optional

    # ContractReference Reference to the contract, if one exists.
    attr :contract_reference, Coercible::Integer.optional, :read_only

    # DueDate Due date of the invoice.
    attr :due_date, Date.optional, Parsers::Date

    # EDIInformation Separate EDIInformation object
    attr :edi_information <=> 'EDIInformation', Structs::EDIInformation

    # EUQuarterlyReport EU Quarterly Report On / Off
    attr :eu_quarterly_report <=> 'EUQuarterlyReport', Bool.optional, Boolean

    # TODO: new attribute
    attr :final_pay_date, String

    # InvoiceDate Invoice date.
    attr :invoice_date, Date.optional, Parsers::Date

    # InvoicePeriodStart Start date of the invoice period.
    attr :invoice_period_start, Date.optional, :read_only, Parsers::Date

    # InvoicePeriodEnd End date of the invoice period.
    attr :invoice_period_end, Date.optional, :read_only, Parsers::Date

    # TODO: This is a new attribute
    attr :invoice_reference, Coercible::Integer.optional

    # InvoiceRows Separate object
    attr :invoice_rows, Strict::Array.of(Structs::InvoiceRow)

    # InvoiceType The type of invoice.
    attr :invoice_type, Coercible::String.optional

    # LastRemindDate Date of last reminder.
    attr :last_remind_date, Date.optional, :read_only, Parsers::Date

    # NoxFinans If the invoice is managed by NoxFinans
    attr :nox_finans, Bool.optional, :read_only, Boolean

    # OCR OCR number of the invoice.
    attr :ocr <=> 'OCR', Coercible::String.optional

    # OrderReference Reference to the order, if one exists.
    attr :order_reference, Coercible::Integer.optional, :read_only

    # TODO: new attribute
    attr :payment_way, String

    # Reminders Number of reminders sent to the customer.
    attr :reminders, Coercible::Integer.optional, :read_only

    # VoucherNumber Voucher number for the invoice.
    attr :voucher_number, Coercible::Integer.optional, :read_only

    # VoucherSeries Voucher series for the invoice.
    attr :voucher_series, Coercible::String.optional, :read_only

    # VoucherYear Voucher year for the invoice.
    attr :voucher_year, Coercible::Integer.optional, :read_only
  end
end
