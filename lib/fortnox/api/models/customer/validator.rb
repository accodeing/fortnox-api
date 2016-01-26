require "fortnox/api/models/validator/base"

module Fortnox
  module API
    module Validators
      class Customer < Fortnox::API::Validators::Base

        validates :name, presence: true

        validates :currency, size: 3
        validates :country_code, size: 2

        validates :sales_account, inclusion: (0..9999)
        validates :type, inclusion: ['PRIVATE', 'COMPANY']
        validates :vat_type, inclusion: ['SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT']

      end
    end
  end
end
