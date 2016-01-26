require "fortnox/api/models/entity/base"

module Fortnox
  module API
    module Entities
      class Row < Fortnox::API::Entities::Base
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
        attribute :discount, Float

        #DiscountType The type of discount used for the row.
        attribute :discount_type, String

        #HouseWork If the row is housework
        attribute :house_work, Boolean

        #HouseWorkHoursToReport Hours to be reported if the quantity of the row should not be used as hours. 5 digits
        attribute :house_work_hours_to_report, Integer

        #HouseWorkType The type of house work.
        attribute :HouseWorkType, String

        #Price Price per unit. 12 digits
        attribute :price, Float

        #PriceExcludingVAT Price per unit excluding VAT.
        attribute :price_excluding_vat, Float, writer: :private

        #Project Code of the project for the row.
        attribute :project, String

        #Total Total amount for the row.
        attribute :total, Float, writer: :private

        #TotalExcludingVAT  Total amount for the row excluding VAT.
        attribute :total_excluding_vat, Float, writer: :private

        #Unit Code of the unit for the row.
        attribute :unit, String

        #VAT VAT percentage of the row.
        attribute :vat, Integer
      end
    end
  end
end
