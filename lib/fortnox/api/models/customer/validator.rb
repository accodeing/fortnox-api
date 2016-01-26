require "fortnox/api/models/validator/base"

module Fortnox
  module API
    module Validators
      class Customer < Fortnox::API::Validators::Base

        attribute :name, presence: true

        attribute :currency, size: 3
        attribute :country_code, size: 2

        attribute :sales_account, inclusion: (0..9999)
        attribute :type, inclusion: ['PRIVATE', 'COMPANY']
        attribute :vat_type, inclusion: ['SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT']

      end
    end
  end
end
