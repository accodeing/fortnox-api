# frozen_string_literal: true

module Fortnox
  module Mappers
    class EmailInformation < Struct
      struct    Structs::EmailInformation
      overrides email_address_cc: 'EmailAddressCC',
                email_address_bcc: 'EmailAddressBCC'
    end
  end
end
