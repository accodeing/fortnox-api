# frozen_string_literal: true

module Fortnox
  module Structs
    class DocumentRow < Fortnox::Struct
      # AccountNumber Account number.
      attribute? :account_number, Types::AccountNumber

      # ArticleNumber Article number.
      attribute? :article_number, Types::Sized::String[50]

      # ContributionPercent Contribution Percent.
      attribute? :contribution_percent, Types::Coercible::Float.optional, :read_only

      # ContributionValue Contribution Value.
      attribute? :contribution_value, Types::Coercible::Float.optional, :read_only

      # CostCenter Code of the cost center for the row.
      attribute? :cost_center, Types::Coercible::String.optional

      # DeliveredQuantity Delivered quantity. 14 digits
      attribute? :delivered_quantity, Types::Sized::Float[-9_999_999_999_999.9, 9_999_999_999_999.9]

      # Description Row description.
      attribute? :description, Types::Sized::String[255]

      # Discount amount. 12 digits (for amount) / 5 digits (for percent)
      # TODO: Verify that we can send in more than 5 digits through
      # the actual API for DiscountType PERCENT. This cannot be done until
      # we fix issue #62...
      attribute? :discount, Types::Sized::Float[0.0, 99_999_999_999.9]

      # DiscountType The type of discount used for the row.
      attribute? :discount_type, Types::DiscountTypes

      # HouseWork If the row is housework
      attribute? :housework, Types::Bool.optional

      # HouseWorkHoursToReport Hours to be reported if the quantity of the row
      # should not be used as hours. 5 digits
      attribute? :housework_hours_to_report, Types::Sized::Integer[0, 99_999].optional

      # HouseWorkType The type of housework.
      attribute? :housework_type, Types::HouseworkTypes.optional

      # Price Price per unit. 12 digits
      attribute? :price, Types::Sized::Float[-99_999_999_999.9, 99_999_999_999.9]

      # Project Code of the project for the row.
      attribute? :project, Types::Coercible::String.optional

      # Total Total amount for the row.
      attribute? :total, Types::Coercible::Float.optional, :read_only

      # Unit Code of the unit for the row.
      attribute? :unit, Types::Coercible::String.optional

      # VAT VAT percentage of the row.
      attribute? :vat, Types::Coercible::Integer.optional
    end
  end
end
