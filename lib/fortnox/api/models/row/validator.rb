require "fortnox/api/models/validator/base"

module Fortnox
  module API
    module Validators
      class Row < Fortnox::API::Validators::Base

        attribute :account_number, inclusion: (0..9999)

      end
    end
  end
end
