# frozen_string_literal: true

module Fortnox
  module Structs
    class DocumentRow < Fortnox::Struct
      using RestEasy::Refinements
      include Fortnox::Types

      # AccountNumber Account number. 4 digits
      attr :account_number, Types::AccountNumber

      # ArticleNumber Article number. 50 characters
      attr :article_number, Types::Sized::String[50]

      # ContributionPercent Contribution Percent.
      attr :contribution_percent, Coercible::Float.optional, :read_only

      # ContributionValue Contribution Value.
      attr :contribution_value, Coercible::Float.optional, :read_only

      # CostCenter Code of the cost center for the row.
      attr :cost_center, Coercible::String.optional

      # DeliveredQuantity Delivered quantity. 14 digits
      attr :delivered_quantity, Types::Sized::Float[-9_999_999_999_999.9, 9_999_999_999_999.9]

      # Description Description Row description. 255 characters
      attr :description, Types::Sized::String[255]

      # Discount amount. 12 digits (for amount) / 5 digits (for percent)
      # TODO(hannes): Verify that we can send in more than 5 digits through
      # the actual API for DiscountType PERCENT. This cannot be done until
      # we fix issue #62...
      attr :discount, Types::Sized::Float[0.0, 99_999_999_999.9]

      # DiscountType The type of discount used for the row.
      attr :discount_type, Types::DiscountTypes

      # HouseWork If the row is housework
      attr :housework <=> 'HouseWork', Bool.optional

      # HouseWorkHoursToReport Hours to be reported if the quantity of the row should not be used as hours.
      # 5 digits
      attr :housework_hours_to_report <=> 'HouseWorkHoursToReport', Types::Sized::Integer[0, 99_999]

      # HouseWorkType The type of housework.
      attr :housework_type <=> 'HouseWorkType', Types::HouseworkTypes

      # Price Price per unit. 12 digits
      attr :price, Types::Sized::Float[-99_999_999_999.9, 99_999_999_999.9]

      # Project Code of the project for the row.
      attr :project, Coercible::String.optional

      # Total Total amount for the row.
      attr :total, Coercible::Float.optional, :read_only

      # Unit Code of the unit for the row.
      attr :unit, Coercible::String.optional

      # VAT VAT percentage of the row.
      attr :vat, Coercible::Integer.optional
    end
  end
end
