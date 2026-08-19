# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

module Fortnox
  module Types
    include Dry.Types()
    include Housework

    # Booleans reach us as strings whenever the caller is a Rails app passing
    # controller params through. Resource attributes already coerce those:
    # rest-easy's `Boolean` is `Dry::Types['params.bool']`, and it wins over
    # the strict type declared alongside it. Struct attributes have to ask for
    # the same coercion explicitly, or the two paths disagree about whether
    # 'true' is a boolean.
    CoercibleBool = Types::Params::Bool

    ArticleTypes = Types::Strict::String.enum(
      'SERVICE', 'STOCK'
    )

    DiscountTypes = Types::Strict::String.enum(
      'AMOUNT', 'PERCENT'
    )

    HouseworkTypes = Types::Strict::String.enum(
      *(CURRENT_HOUSEWORK_TYPES + LEGACY_HOUSEWORK_TYPES)
    )

    Currencies = Types::Strict::String.enum(
      'AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN',
      'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV',
      'BRL', 'BSD', 'BTN', 'BWP', 'BYR', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF',
      'CHW', 'CLF', 'CLP', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK',
      'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP',
      'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL',
      'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD',
      'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW', 'KRW', 'KWD',
      'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL',
      'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRO', 'MUR', 'MVR', 'MWK', 'MXN',
      'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR',
      'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD',
      'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLL',
      'SOS', 'SRD', 'SSP', 'STD', 'SYP', 'SZL', 'THB', 'TJS', 'TMM', 'TND',
      'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'USS',
      'UYU', 'UZS', 'VEF', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA',
      'XBB', 'XBC', 'XBD', 'XCD', 'XDR', 'XFU', 'XOF', 'XPD', 'XPF', 'XPT',
      'XTS', 'XXX', 'YER', 'ZAR', 'ZMK', 'ZWD'
    )

    CustomerTypes = Types::Strict::String.enum(
      'PRIVATE', 'COMPANY'
    )

    VATTypes = Types::Strict::String.enum(
      'SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT'
    )

    DefaultDeliveryTypeValues = Types::Strict::String.enum(
      'PRINT', 'EMAIL', 'PRINTSERVICE'
    )

    DefaultInvoiceDeliveryTypeValues = Types::Strict::String.enum(
      'PRINT', 'EMAIL', 'PRINTSERVICE', 'ELECTRONICINVOICE'
    )

    AccountingMethods = Types::Strict::String.enum(
      '', 'ACCRUAL', 'CASH'
    )

    DeliveryStates = Types::Strict::String.enum(
      '', 'registration', 'reservation', 'delivery'
    )

    PaymentWays = Types::Strict::String.enum(
      '', 'CASH', 'CARD', 'AG'
    )

    ProjectStatusTypes = Types::Strict::String.enum(
      'NOTSTARTED', 'ONGOING', 'COMPLETED'
    )

    InvoiceTypes = Types::Strict::String.enum(
      '', 'INVOICE', 'AGREEMENTINVOICE', 'INTRESTINVOICE', 'SUMMARYINVOICE', 'CASHINVOICE'
    )

    TaxReductionTypes = Types::Strict::String.enum(
      '', 'none', 'rot', 'rut', 'green'
    )

    # Fortnox silently ignores "" in update payloads — updating an
    # attribute to '' keeps the original value; only an explicit null
    # clears it. On reads, Fortnox spells "unset" as "" or null depending
    # on endpoint and record history. Normalise at the type boundary:
    # blank coerces to nil on parse and update alike, so "no value" is
    # always nil in the model and always null on the wire. (Enum types
    # that include '' as a valid member are exempt on purpose.)
    BLANK_TO_NIL = ->(value) { value == '' ? nil : value }

    # Fortnox sometimes returns "" for unset attributes using AccountNumber as type.
    # Without the blank normalisation, "" falls through to Coercible::Integer and
    # `Integer("")` raises, surfacing as Fortnox::ConstraintError.
    AccountNumber = Coercible::Integer
                    .constrained(gteq: 0, lteq: 9999)
                    .optional
                    .constructor(BLANK_TO_NIL)

    Email = Strict::String
            .constrained(max_size: 1024, format: /\A[[[:alnum:]]+-_.]+@[[[:alnum:]]+-_.]+\.[a-z]+\z/i)
            .optional
            .constructor { |value| BLANK_TO_NIL[value]&.to_s&.downcase }

    UnsizedString = Types::Coercible::String
                    .optional
                    .constructor(BLANK_TO_NIL)

    UnsizedInteger = Types::Coercible::Integer
                     .optional
                     .constructor(BLANK_TO_NIL)

    UnsizedFloat = Types::Coercible::Float
                   .optional
                   .constructor(BLANK_TO_NIL)

    module Sized
      module String
        def self.[](size)
          Types::Coercible::String
            .constrained(max_size: size)
            .optional
            .constructor(BLANK_TO_NIL)
        end
      end

      module Integer
        def self.[](low, high)
          Types::Coercible::Integer
            .constrained(gteq: low, lteq: high)
            .optional
            .constructor(BLANK_TO_NIL)
        end
      end

      module Float
        def self.[](low, high)
          Types::Coercible::Float
            .constrained(gteq: low, lteq: high)
            .optional
            .constructor(BLANK_TO_NIL)
        end
      end
    end

    require 'fortnox/structs/default_delivery_types'
    require 'fortnox/structs/default_templates'
    require 'fortnox/structs/email_information'
    require 'fortnox/structs/edi_information'
    require 'fortnox/structs/invoice_row'
    require 'fortnox/structs/order_row'
  end
end
