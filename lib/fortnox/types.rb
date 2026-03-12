# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require 'countries'
require 'fortnox/types/shim/country_code_string'

module Dry
  module Types
    module Options
      def is(*option_names)
        new_options = option_names.each_with_object({}) do |name, hash|
          hash[name] = true
        end
        with( **new_options )
      end

      def is?(option_name)
        @options[option_name]
      end
    end
  end
end

module Fortnox
  module Types
    include Dry.Types()
    ISO3166.configure { |config| config.locales = %i[en sv] }

    THE_TRUTH = { true => true, 'true' => true, false => false, 'false' => false }.freeze

    require 'fortnox/types/required'
    require 'fortnox/types/defaulted'
    require 'fortnox/types/nullable'

    require 'fortnox/types/enums'

    require 'fortnox/types/sized'

    AccountNumber = Strict::Integer
                    .constrained(gteq: 0, lteq: 9999)
                    .optional

    ArticleType = Strict::String
                  .constrained(included_in: ArticleTypes.values)
                  .optional
                  .constructor(EnumConstructors.default)

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
            .constrained(max_size: 1024, format: /^$|\A[[[:alnum:]]+-_.]+@[[[:alnum:]]+-_.]+\.[a-z]+\z/i)
            .optional
            .constructor { |v| v.to_s.downcase unless v.nil? }

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

    require 'fortnox/types/default_delivery_types'
    require 'fortnox/types/default_templates'
    require 'fortnox/types/email_information'
    require 'fortnox/types/edi_information'
    require 'fortnox/types/invoice_row'
    # require 'fortnox/types/order_row'  # TODO: needs migration — with_stub is a Resource method, not Model
  end
end
