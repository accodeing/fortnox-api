# frozen_string_literal: true

module Fortnox
  class Invoice < Document
    using RestEasy::Refinements

    configure do
      path 'invoices'
      instance_wrapper 'Invoice'
      collection_wrapper 'Invoices'
      scope 'invoice'
    end

    # AccountingMethod Accounting Method.
    attr :accounting_method, AccountingMethods

    # Balance Balance of the invoice.
    attr :balance, Coercible::Float.optional, :read_only

    # Booked If the invoice is bookkept.
    attr :booked, Bool.optional, :read_only, Boolean

    # Credit If the invoice is a credit invoice.
    attr :credit, Bool.optional, :read_only, Boolean

    # CreditInvoiceReference Reference to the credit invoice, if one exists.
    attr :credit_invoice_reference, Coercible::Integer.optional

    # ContractReference Reference to the contract, if one exists.
    attr :contract_reference, Coercible::Integer.optional, :read_only

    # DueDate Due date of the invoice.
    attr :due_date, Date.optional, Mappers::Date

    # EDIInformation Separate EDIInformation object
    attr :edi_information <=> 'EDIInformation', Structs::EDIInformation, Mappers::EDIInformation

    # EUQuarterlyReport EU Quarterly Report On / Off
    attr :eu_quarterly_report <=> 'EUQuarterlyReport', Bool.optional, Boolean

    # FinalPayDate Final pay date of the invoice.
    attr :final_pay_date, Date.optional, Mappers::Date

    # InvoiceDate Invoice date.
    attr :invoice_date, Date.optional, Mappers::Date

    # InvoicePeriodStart Start date of the invoice period.
    attr :invoice_period_start, Date.optional, :read_only, Mappers::Date

    # InvoicePeriodEnd End date of the invoice period.
    attr :invoice_period_end, Date.optional, :read_only, Mappers::Date

    # InvoicePeriodReference Reference to the invoice period.
    attr :invoice_period_reference, Coercible::String.optional

    # InvoiceReference Reference to another invoice.
    attr :invoice_reference, Coercible::String.optional

    # InvoiceRows Separate object
    attr :invoice_rows, Strict::Array.of(Structs::InvoiceRow), Mappers::StructArray.for(Mappers::InvoiceRow)

    # InvoiceType The type of invoice.
    attr :invoice_type, InvoiceTypes

    # LastRemindDate Date of last reminder.
    attr :last_remind_date, Date.optional, :read_only, Mappers::Date

    # NoxFinans If the invoice is managed by NoxFinans
    attr :nox_finans, Bool.optional, :read_only, Boolean

    # OCR OCR number of the invoice.
    attr :ocr <=> 'OCR', Coercible::String.optional

    # OrderReference Reference to the order, if one exists.
    attr :order_reference, Coercible::Integer.optional, :read_only

    # PaymentWay Payment way of the invoice.
    attr :payment_way, PaymentWays

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
