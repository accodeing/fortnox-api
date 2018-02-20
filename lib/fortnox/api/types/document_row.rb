# frozen_string_literal: true

module Fortnox
  module API
    module Types
      module DocumentRow
        def self.ify(base)
          base.class_eval do
            # AccountNumber Account number. 4 digits
            attribute :account_number, Types::AccountNumber

            # ArticleNumber Article number. 50 characters
            attribute :article_number, Types::Sized::String[50]

            # ContributionPercent Contribution Percent.
            attribute :contribution_percent, Types::Nullable::Float.with(private: true)

            # ContributionValue Contribution Value.
            attribute :contribution_value, Types::Nullable::Float.with(private: true)

            # CostCenter Code of the cost center for the row.
            attribute :cost_center, Types::Nullable::String

            # DeliveredQuantity Delivered quantity. 14 digits
            attribute :delivered_quantity, Types::Sized::Float[0.0, 9_999_999_999_999.9]

            # Description Description Row description. 50 characters
            attribute :description, Types::Sized::String[50]

            # Discount amount. 12 digits (for amount) / 5 digits (for percent)
            # TODO(hannes): Verify that we can send in more than 5 digits through
            # the actual API for DiscountType PERCENT. This cannot be done until
            # we fix issue #62...
            attribute :discount, Types::Sized::Float[0.0, 99_999_999_999.9]

            # DiscountType The type of discount used for the row.
            attribute :discount_type, Types::DiscountType

            # HouseWork If the row is housework
            attribute :house_work, Types::Nullable::Boolean

            # HouseWorkHoursToReport Hours to be reported if the quantity of the row should not be used as hours. 5 digits
            attribute :house_work_hours_to_report, Types::Sized::Integer[0, 99_999]

            # HouseWorkType The type of house work.
            attribute :house_work_type, Types::HouseWorkType

            # Price Price per unit. 12 digits
            attribute :price, Types::Sized::Float[0.0, 99_999_999_999.9]

            # Project Code of the project for the row.
            attribute :project, Types::Nullable::String

            # Total Total amount for the row.
            attribute :total, Types::Nullable::Float.with(private: true)

            # Unit Code of the unit for the row.
            attribute :unit, Types::Nullable::String

            # VAT VAT percentage of the row.
            attribute :vat, Types::Nullable::Integer
          end
        end
      end
    end
  end
end
