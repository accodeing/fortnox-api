require "fortnox/api/validators/base"

module Fortnox
  module API
    module Validator
      class Row

        extend Fortnox::API::Validator::Base

        using_validations do
          validates_length_of :article_number,  length: 0..50,  if: :article_number?
          validates_length_of :description,     length: 0..50,  if: :description?

          validates_inclusion_of :account_number,              within: (0..9999), if: :account_number?
          validates_inclusion_of :delivered_quantity,          within: (0..9_999_999_999_999.0), if: :delivered_quantity?
          validates_inclusion_of :discount,                    within: (0..99_999_999_999.0), if: :discount?
          validates_inclusion_of :house_work_hours_to_report,  within: (0..99_999), if: :house_work_hours_to_report?
          validates_inclusion_of :price,                       within: (0..99_999_999_999.0), if: :price?
        end
      end
    end
  end
end
