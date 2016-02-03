require "fortnox/api/validators/base"

module Fortnox
  module API
    module Validator
      class EDIInformation

        extend Fortnox::API::Validator::Base

        using_validations do
          # No validations needed, in other words always valid.
        end
      end
    end
  end
end
