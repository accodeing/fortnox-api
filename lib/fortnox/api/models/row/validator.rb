require "fortnox/api/models/validator/base"

module Fortnox
  module API
    module Validators
      class Row < Fortnox::API::Validators::Base

        attribute :account_number, inclusion: (0..9999)
        attribute :article_number, size: 1..50
        attribute :delivered_quantity, inclusion: (0..99_999_999_999_999)
        attribute :description, size: 1..50
        attribute :discount, inclusion: (0..999_999_999_999)
        attribute :house_work_hours_to_report, inclusion: (0..99_999)
        attribute :price, inclusion: (0..999_999_999_999)

      end
    end
  end
end
