require "fortnox/api/models/validator/base"

module Fortnox
  module API
    module Validators
      class Row < Fortnox::API::Validators::Base

        attribute :account_number, inclusion: (0..9999)
        attribute :article_number, size: 1..50
        attribute :delivered_quantity, inclusion: (0..99999999999999)
        attribute :description, size: 1..50

      end
    end
  end
end
