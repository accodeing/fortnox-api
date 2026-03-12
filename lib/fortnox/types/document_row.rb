# frozen_string_literal: true

module Fortnox
  module Types
    class DocumentRow < Dry::Struct
      transform_keys do |key|
        RestEasy::Conventions::PascalCase.new.parse(key)
      end

      # AccountNumber Account number. 4 digits
      attribute? :account_number, AccountNumber

      # ArticleNumber Article number. 50 characters
      attribute? :article_number, Sized::String[50]

      # ContributionPercent Contribution Percent.
      attribute? :contribution_percent, Nullable::Float.with(private: true)

      # ContributionValue Contribution Value.
      attribute? :contribution_value, Nullable::Float.with(private: true)

      # CostCenter Code of the cost center for the row.
      attribute? :cost_center, Nullable::String

      # DeliveredQuantity Delivered quantity. 14 digits
      attribute? :delivered_quantity, Sized::Float[-9_999_999_999_999.9, 9_999_999_999_999.9]

      # Description Description Row description. 255 characters
      attribute? :description, Sized::String[255]

      # Discount amount. 12 digits (for amount) / 5 digits (for percent)
      # TODO(hannes): Verify that we can send in more than 5 digits through
      # the actual API for DiscountType PERCENT. This cannot be done until
      # we fix issue #62...
      attribute? :discount, Sized::Float[0.0, 99_999_999_999.9]

      # DiscountType The type of discount used for the row.
      attribute? :discount_type, DiscountTypes

      # HouseWork If the row is housework
      attribute? :housework, Nullable::Boolean

      # HouseWorkHoursToReport Hours to be reported if the quantity of the row should not be used as hours.
      # 5 digits
      attribute? :housework_hours_to_report, Sized::Integer[0, 99_999]

      # HouseWorkType The type of housework.
      attribute? :housework_type, HouseworkTypes

      # Price Price per unit. 12 digits
      attribute? :price, Sized::Float[-99_999_999_999.9, 99_999_999_999.9]

      # Project Code of the project for the row.
      attribute? :project, Nullable::String

      # Total Total amount for the row.
      attribute? :total, Nullable::Float.with(private: true)

      # Unit Code of the unit for the row.
      attribute? :unit, Nullable::String

      # VAT VAT percentage of the row.
      attribute? :vat, Nullable::Integer
    end
  end
end
