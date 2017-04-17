require "fortnox/api/models/validator/base"

module Fortnox
  module API
    module Validators
      class Row

        extend Fortnox::API::Entities::BaseValidator

        using_validations do

          validates_inclusion_of :account_number, within: (0..9999), if: :account_number

        end
      end
    end
  end
end
