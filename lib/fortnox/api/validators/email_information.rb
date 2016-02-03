require "fortnox/api/validators/base"

module Fortnox
  module API
    module Validator
      class EmailInformation

        extend Fortnox::API::Validator::Base

        using_validations do
          validates_length_of :email_address_to, length: 0..1024, if: :email_address_to?
          validates_length_of :email_address_cc, length: 0..1024, if: :email_address_cc?
          validates_length_of :email_address_bcc, length: 0..1024, if: :email_address_bcc?
          validates_length_of :email_subject, length: 0..100, if: :email_subject?
          validates_length_of :email_body, length: 0..20000, if: :email_body?
        end
      end
    end
  end
end
