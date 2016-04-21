require "fortnox/api/models/base"

module Fortnox
  module API
    module Model
      module DocumentRow
        DISCOUNT_TYPES = %w(AMOUNT PERCENT)
        HOUSE_WORK_TYPES = %w(CONSTRUCTION ELECTRICITY GLASSMETALWORK GROUNDDRAINAGEWORK MASONRY PAINTINGWALLPAPERING HVAC CLEANING TEXTILECLOTHING COOKING SNOWPLOWING GARDENING BABYSITTING OTHERCARE TUTORING OTHERCOSTS)

        def discount_type=( raw_discount_type )
          discount_type = raw_discount_type.upcase
          super discount_type if DISCOUNT_TYPES.include? discount_type
        end

        def house_work_type=( raw_house_work_type )
          house_work_type = raw_house_work_type.upcase
          super house_work_type if HOUSE_WORK_TYPES.include? house_work_type
        end

        def self.included(base)

          #AccountNumber Account number. 4 digits
          base.attribute :account_number, Integer

          #ArticleNumber Article number. 50 characters
          base.attribute :article_number, String

          #ContributionPercent Contribution Percent.
          base.attribute :contribution_percent, Float, writer: :private

          #ContributionValue Contribution Value.
          base.attribute :contribution_value, Float, writer: :private

          #CostCenter Code of the cost center for the row.
          base.attribute :cost_center, String

          #DeliveredQuantity Delivered quantity. 14 digits
          base.attribute :delivered_quantity, Float

          #Description Description Row description. 50 characters
          base.attribute :description, String

          # Discount amount. 12 digits (for amount) / 5 digits (for percent)
          # TODO: Verify that we can send in more than 5 digits through the actual
          # API for DiscountType PERCENT.
          base.attribute :discount, Float

          #DiscountType The type of discount used for the row.
          base.attribute :discount_type, String

          #HouseWork If the row is housework
          base.attribute :house_work, base::Boolean

          #HouseWorkHoursToReport Hours to be reported if the quantity of the row should not be used as hours. 5 digits
          base.attribute :house_work_hours_to_report, Integer

          #HouseWorkType The type of house work.
          base.attribute :house_work_type, String

          #Price Price per unit. 12 digits
          base.attribute :price, Float


          #Project Code of the project for the row.
          base.attribute :project, String

          #Total Total amount for the row.
          base.attribute :total, Float, writer: :private

          #Unit Code of the unit for the row.
          base.attribute :unit, String

          #VAT VAT percentage of the row.
          base.attribute :vat, Integer
        end
      end
    end
  end
end
