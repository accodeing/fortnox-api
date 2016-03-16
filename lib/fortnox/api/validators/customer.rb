require "fortnox/api/validators/base"
require "fortnox/api/validators/attributes/country_code"
require "fortnox/api/validators/attributes/currency"

module Fortnox
  module API
    module Validator
      class Customer < Fortnox::API::Validator::Base

        include Fortnox::API::Validator::Attribute::CountryCode
        include Fortnox::API::Validator::Attribute::Currency

        using_validations do

          VAT_TYPES = ['SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT']
          TYPES = ['PRIVATE', 'COMPANY']

          validates_presence_of :name

          validates_inclusion_of :sales_account,  within: (0..9999),  if: :sales_account?
          validates_inclusion_of :type,           within: TYPES,      if: :type?
          validates_inclusion_of :vat_type,       within: VAT_TYPES,  if: :vat_type?

        end

      end
    end
  end
end
