# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require 'countries'
require_relative 'types/shim/country_string'

module Dry
  module Types
    module Options
      def is(*option_names)
        new_options = option_names.each_with_object({}) do |name, hash|
          hash[name] = true
        end
        with(**new_options)
      end
    end
  end
end

module Fortnox
  module API
    module Types
      include Dry.Types(default: :nominal)
      ISO3166.configure { |config| config.locales = %i[en sv] }

      THE_TRUTH = { true => true, 'true' => true, false => false, 'false' => false }.freeze

      require_relative 'types/required'
      require_relative 'types/defaulted'
      require_relative 'types/nullable'

      require_relative 'types/enums'
      require_relative 'types/sized'

      AccountNumber = Strict::Integer
                      .constrained(gteq: 0, lteq: 9999)
                      .optional
                      .constructor do |value|
                        next nil if value.nil? || value == ''

                        value
                      end

      ArticleType = Strict::String
                    .constrained(included_in: ArticleTypes.values)
                    .optional
                    .constructor(EnumConstructors.default)

      Country = Strict::String
                .optional
                .constructor do |value|
                  next value if value.nil? || value == ''

                  # Fortnox only supports Swedish translation of Sweden
                  next CountryString.new('SE') if value.match?(/^s(e$|we|ve)/i)

                  country = ::ISO3166::Country[value] ||
                            ::ISO3166::Country.find_country_by_any_name(value) ||
                            ::ISO3166::Country.find_country_by_translated_names(value)

                  raise Dry::Types::ConstraintError.new('value violates constraints', value) if country.nil?

                  CountryString.new(country.alpha2)
                end

      CountryCode = Strict::String
                    .optional
                    .constructor do |value|
                      next value if value.nil? || value == ''

                      country = ::ISO3166::Country[value]

                      raise Dry::Types::ConstraintError.new('value violates constraints', value) if country.nil?

                      country.alpha2
                    end

      Currency = Strict::String
                 .constrained(included_in: Currencies.values)
                 .optional
                 .constructor(EnumConstructors.sized(3))
      CustomerType = Strict::String
                     .constrained(included_in: CustomerTypes.values)
                     .optional
                     .constructor(EnumConstructors.default)

      DiscountType = Strict::String
                     .constrained(included_in: DiscountTypes.values)
                     .optional
                     .constructor(EnumConstructors.default)

      Email = Strict::String
              .constrained(max_size: 1024, format: /^$|\A[[[:alnum:]]+-_.]+@[\w+-_.]+\.[a-z]+\z/i)
              .optional
              .constructor { |v| v&.to_s&.downcase }

      HouseworkType = Strict::String
                      .constrained(included_in: HouseworkTypes.values)
                      .optional
                      .constructor(EnumConstructors.default)

      VATType = Strict::String
                .constrained(included_in: VATTypes.values)
                .optional
                .constructor(EnumConstructors.default)

      DefaultDeliveryType = Strict::String
                            .constrained(included_in: DefaultDeliveryTypeValues.values)
                            .optional
                            .constructor(EnumConstructors.default)

      ProjectStatusType = Strict::String
                          .constrained(included_in: ProjectStatusTypes.values)
                          .optional
                          .constructor(EnumConstructors.default)

      TaxReductionType = Strict::String
                         .constrained(included_in: TaxReductionTypes.values)
                         .optional
                         .constructor(EnumConstructors.lower_case)

      # Some Fortnox endpoints returns a String and some returns an Integer...
      # The documentation says it should be a string, so let's keep it as a string.
      SalesAccount = Strict::String
                     .constrained(format: /^[0-9]{4}$/)
                     .optional
                     .constructor do |value|
                       next nil if value == '' || value.nil?
                       next value.to_s if value.is_a?(::Integer)

                       value
                     end

      require_relative 'types/model'
      require_relative 'types/default_delivery_types'
      require_relative 'types/default_templates'
      require_relative 'types/email_information'
      require_relative 'types/edi_information'
      require_relative 'types/invoice_row'
      require_relative 'types/order_row'
    end
  end
end
