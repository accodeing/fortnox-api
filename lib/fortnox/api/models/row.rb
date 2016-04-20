require "fortnox/api/models/base"

module Fortnox
  module API
    module Model
      class Row < Fortnox::API::Model::Base

        DISCOUNT_TYPES = %w(AMOUNT PERCENT)
        HOUSE_WORK_TYPES = %w(CONSTRUCTION ELECTRICITY GLASSMETALWORK GROUNDDRAINAGEWORK MASONRY PAINTINGWALLPAPERING HVAC CLEANING TEXTILECLOTHING COOKING SNOWPLOWING GARDENING BABYSITTING OTHERCARE TUTORING OTHERCOSTS)

        #AccountNumber Account number. 4 digits
        attribute :account_number, Integer

        #ArticleNumber Article number. 50 characters
        attribute :article_number, String

        #ContributionPercent Contribution Percent.
        attribute :contribution_percent, Float, writer: :private

        #ContributionValue Contribution Value.
        attribute :contribution_value, Float, writer: :private

        #CostCenter Code of the cost center for the row.
        attribute :cost_center, String

        #DeliveredQuantity Delivered quantity. 14 digits
        attribute :delivered_quantity, Float

        #Description Description Row description. 50 characters
        attribute :description, String

        # Discount amount. 12 digits (for amount) / 5 digits (for percent)
        # TODO: Verify that we can send in more than 5 digits through the actual
        # API for DiscountType PERCENT.
        attribute :discount, Float

        #DiscountType The type of discount used for the row.
        attribute :discount_type, String

        #HouseWork If the row is housework
        attribute :house_work, Boolean

        #HouseWorkHoursToReport Hours to be reported if the quantity of the row should not be used as hours. 5 digits
        attribute :house_work_hours_to_report, Integer

        #HouseWorkType The type of house work.
        attribute :house_work_type, String

        #Price Price per unit. 12 digits
        attribute :price, Float


        #Project Code of the project for the row.
        attribute :project, String

        #Total Total amount for the row.
        attribute :total, Float, writer: :private

        #Unit Code of the unit for the row.
        attribute :unit, String

        #VAT VAT percentage of the row.
        attribute :vat, Integer

        def discount_type=( raw_discount_type )
          discount_type = raw_discount_type.upcase
          super discount_type if DISCOUNT_TYPES.include? discount_type
        end

        def house_work_type=( raw_house_work_type )
          house_work_type = raw_house_work_type.upcase
          super house_work_type if HOUSE_WORK_TYPES.include? house_work_type
        end
      end
    end
  end
end
