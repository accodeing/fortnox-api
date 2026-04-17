# frozen_string_literal: true

module Fortnox
  module Structs
    class DocumentRow < Dry::Struct
      include Fortnox::Types

      transform_keys do |key|
        RestEasy::Conventions::PascalCase.new.parse(key)
      end

      # AccountNumber Account number. 4 digits
      attribute? :account_number, Types::AccountNumber

      # ArticleNumber Article number. 50 characters
      attribute? :article_number, Types::Sized::String[50]

      # ContributionPercent Contribution Percent.
      attribute? :contribution_percent, Coercible::Float.optional.with(private: true)

      # ContributionValue Contribution Value.
      attribute? :contribution_value, Coercible::Float.optional.with(private: true)

      # CostCenter Code of the cost center for the row.
      attribute? :cost_center, Coercible::String.optional

      # DeliveredQuantity Delivered quantity. 14 digits
      attribute? :delivered_quantity, Types::Sized::Float[-9_999_999_999_999.9, 9_999_999_999_999.9]

      # Description Description Row description. 255 characters
      attribute? :description, Types::Sized::String[255]

      # Discount amount. 12 digits (for amount) / 5 digits (for percent)
      # TODO(hannes): Verify that we can send in more than 5 digits through
      # the actual API for DiscountType PERCENT. This cannot be done until
      # we fix issue #62...
      attribute? :discount, Types::Sized::Float[0.0, 99_999_999_999.9]

      # DiscountType The type of discount used for the row.
      attribute? :discount_type, Types::DiscountTypes

      # HouseWork If the row is housework
      attribute? :housework, Bool.optional

      # HouseWorkHoursToReport Hours to be reported if the quantity of the row should not be used as hours.
      # 5 digits
      attribute? :housework_hours_to_report, Types::Sized::Integer[0, 99_999]

      # HouseWorkType The type of housework.
      attribute? :housework_type, Types::HouseworkTypes

      # Price Price per unit. 12 digits
      attribute? :price, Types::Sized::Float[-99_999_999_999.9, 99_999_999_999.9]

      # Project Code of the project for the row.
      attribute? :project, Coercible::String.optional

      # Total Total amount for the row.
      attribute? :total, Coercible::Float.optional.with(private: true)

      # Unit Code of the unit for the row.
      attribute? :unit, Coercible::String.optional

      # VAT VAT percentage of the row.
      attribute? :vat, Coercible::Integer.optional
    end
  end
end
