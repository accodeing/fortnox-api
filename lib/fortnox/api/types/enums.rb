# frozen_string_literal: true

module Fortnox
  module API
    module Types
      module EnumConstructors
        def self.sized(size)
          lambda do |value|
            return nil if value == ''
            value.to_s.upcase[0...size] unless value.nil?
          end
        end

        def self.default
          lambda do |value|
            return nil if value == ''
            value.to_s.upcase unless value.nil?
          end
        end

        def self.lower_case
          lambda do |value|
            return nil if value == ''
            value.to_s.downcase unless value.nil?
          end
        end
      end

      ArticleTypes = Types::Strict::String.enum(
        'SERVICE', 'STOCK'
      )
      DiscountTypes = Types::Strict::String.enum(
        'AMOUNT', 'PERCENT'
      )
      ROT_HOUSEWORK_TYPES = %w[
        CONSTRUCTION ELECTRICITY GLASSMETALWORK GROUNDDRAINAGEWORK
        MASONRY PAINTINGWALLPAPERING HVAC OTHERCOSTS
      ].freeze
      RUT_HOUSEWORK_TYPES = %w[
        MAJORAPPLIANCEREPAIR MOVINGSERVICES ITSERVICES CLEANING
        TEXTILECLOTHING SNOWPLOWING GARDENING BABYSITTING OTHERCARE
        OTHERCOSTS
      ].freeze

      # TODO: RUT to be added:
      # HOMEMAINTENANCE FURNISHING TRANSPORTATIONSERVICES
      # WASHINGANDCAREOFCLOTHING
      #
      # TODO: GREEN to be added:
      # SOLARCELLS STORAGESELFPRODUCEDELECTRICTY
      # CHARGINGSTATIONELECTRICVEHICLE OTHERCOSTS

      LEGACY_RUT_HOUSEWORK_TYPES = %w[COOKING TUTORING].freeze
      HouseworkTypes = Types::Strict::String.enum(
        *(ROT_HOUSEWORK_TYPES +
          RUT_HOUSEWORK_TYPES +
          LEGACY_RUT_HOUSEWORK_TYPES).uniq
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
      ProjectStatusTypes = Types::Strict::String.enum(
        'NOTSTARTED', 'ONGOING', 'COMPLETED'
      )
      # NOTE: Yes, these needs to be in lower case...
      # I know, this is stupid... Fortnox: why?!
      TaxReductionTypes = Types::Strict::String.enum(
        'rot', 'rut', 'green', 'none'
      )
    end
  end
end
