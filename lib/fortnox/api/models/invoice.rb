require "fortnox/api/models/order_base"
require "fortnox/api/models/edi_information"
require "fortnox/api/models/invoice_row"

module Fortnox
  module API
    module Model
      class Invoice < Fortnox::API::Model::Base
        include OrderBase

        #UrlTaxReductionList Direct url to the tax reduction for the invoice.
        attribute :url_tax_reduction_list, String, writer: :private

        #AccountingMethod Accounting Method.
        attribute :accounting_method, String

        #Balance Balance of the invoice.
        attribute :balance, Float, writer: :private

        #Booked If the invoice is bookkept.
        attribute :booked, Boolean, writer: :private

        #Credit If the invoice is a credit invoice.
        attribute :credit, Boolean, writer: :private

        #CreditInvoiceReference Reference to the credit invoice, if one exits.
        attribute :credit_invoice_reference, Integer

        #ContractReference Reference to the contract, if one exists.
        attribute :contract_reference, Integer, writer: :private

        #DueDate Due date of the invoice.
        attribute :due_date, Date

        #EDIInformation Separate EDIInformation object
        attribute :edi_information, EDIInformation

        #EUQuarterlyReport EU Quarterly Report On / Off
        attribute :eu_quarterly_report, Boolean

        #InvoiceDate Invoice date.
        attribute :invoice_date, Date

        #InvoicePeriodStart Start date of the invoice period.
        attribute :invoice_period_start, Date, writer: :private

        #InvoicePeriodEnd End date of the invoice period.
        attribute :invoice_period_end, Date, writer: :private

        #InvoiceRows Separate object
        attribute :invoice_rows, Array[InvoiceRow]

        #InvoiceType The type of invoice.
        attribute :invoice_type, String

        #Language Language code.
        attribute :language, String

        #LastRemindDate Date of last reminder.
        attribute :last_remind_date, Date, writer: :private

        #NoxFinans If the invoice is managed by NoxFinans
        attribute :nox_finans, Boolean, writer: :private

        #OCR OCR number of the invoice.
        attribute :ocr, String

        #OrderReference Reference to the order, if one exists.
        attribute :order_reference, Integer, writer: :private

        #Reminders Number of reminders sent to the customer.
        attribute :reminders, Integer, writer: :private

        #VoucherNumber Voucher number for the invoice.
        attribute :voucher_number, Integer, writer: :private

        #VoucherSeries Voucher series for the invoice.
        attribute :voucher_series, String, writer: :private

        #VoucherYear Voucher year for the invoice.
        attribute :voucher_year, Integer, writer: :private
      end
    end
  end
end
