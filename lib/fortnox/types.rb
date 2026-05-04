# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require 'countries'

module Fortnox
  module Types
    include Dry.Types()

    ISO3166.configure { |config| config.locales = [:en, :sv] }

    THE_TRUTH = { true => true, 'true' => true, false => false, 'false' => false }.freeze

    ArticleTypes = Types::Strict::String.enum(
      'SERVICE', 'STOCK'
    )

    DiscountTypes = Types::Strict::String.enum(
      'AMOUNT', 'PERCENT'
    )

    CURRENT_HOUSEWORK_TYPES = [
      'CONSTRUCTION', 'ELECTRICITY', 'GLASSMETALWORK', 'GROUNDDRAINAGEWORK',
      'MASONRY', 'PAINTINGWALLPAPERING', 'HVAC', 'MAJORAPPLIANCEREPAIR',
      'MOVINGSERVICES', 'ITSERVICES', 'CLEANING', 'TEXTILECLOTHING',
      'SNOWPLOWING', 'GARDENING', 'BABYSITTING', 'OTHERCARE', 'OTHERCOSTS',
      'FURNISHING', 'HOMEMAINTENANCE', 'TRANSPORTATIONSERVICES',
      'WASHINGANDCAREOFCLOTHING', 'SOLARCELLS', 'STORAGESELFPRODUCEDELECTRICITY',
      'CHARGINGSTATIONELECTRICVEHICLE', 'EMPTYHOUSEWORK'
    ].freeze

    LEGACY_HOUSEWORK_TYPES = ['COOKING', 'TUTORING'].freeze

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
      'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KUR', 'KMF', 'KPW', 'KRW', 'KWD',
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

    AccountNumber = Coercible::Integer
                    .constrained(gteq: 0, lteq: 9999)
                    .optional

    Email = Strict::String
            .constrained(max_size: 1024, format: /\A\z|\A[[[:alnum:]]+-_.]+@[[[:alnum:]]+-_.]+\.[a-z]+\z/i)
            .optional
            .constructor { |v| v&.to_s&.downcase }

    module Sized
      module String
        def self.[](size)
          Types::Coercible::String.constrained(max_size: size).optional
        end
      end

      module Integer
        def self.[](low, high)
          Types::Coercible::Integer.constrained(gteq: low, lteq: high).optional
        end
      end

      module Float
        def self.[](low, high)
          Types::Coercible::Float.constrained(gteq: low, lteq: high).optional
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
