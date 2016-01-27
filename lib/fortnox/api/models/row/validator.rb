require "fortnox/api/models/validator/base"

module Fortnox
  module API
    module Validators
      class Row < Fortnox::API::Validators::Base

        validates :article_number, size: 1..50
        validates :description, size: 1..50

        validates :account_number, inclusion: (0..9999)
        validates :delivered_quantity, inclusion: (0..99_999_999_999_999)
        validates :discount, inclusion: (0..999_999_999_999)
        validates :house_work_hours_to_report, inclusion: (0..99_999)
        validates :price, inclusion: (0..999_999_999_999)

      end
    end
  end
end
