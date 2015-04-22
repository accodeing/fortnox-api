require "fortnox/api/validator"

module Fortnox
  module API
    module Customer
      class Validator

        extend Fortnox::API::Validator

        using_validations do

          validates_presence_of :name

          validates_length_of :currency, length: 3, if: :currency
          validates_length_of :country_code, length: 2, if: :country_code

          validates_inclusion_of :sales_account, within: (0..9999), if: :sales_account
          validates_inclusion_of :type, within: ['PRIVATE', 'COMPANY'], if: :type
          validates_inclusion_of :vat_type, within: ['SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT'], if: :vat_type

        end

      end
    end
  end
end
