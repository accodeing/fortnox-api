require "fortnox/api/validators/base"

module Fortnox
  module API
    module Validator
      class Customer

        extend Fortnox::API::Validator::Base

        using_validations do

          VAT_TYPES = ['SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT']

          validates_presence_of :name

          validates_inclusion_of :sales_account,  within: (0..9999),               if: :sales_account?
          validates_inclusion_of :type,           within: ['PRIVATE', 'COMPANY'],  if: :type?
          validates_inclusion_of :vat_type,       within: VAT_TYPES,               if: :vat_type?

        end

      end
    end
  end
end
