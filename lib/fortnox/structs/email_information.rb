# frozen_string_literal: true

module Fortnox
  module Structs
    class EmailInformation < Fortnox::Struct
      # EmailAddressTo Customer e-mail address. Must be a valid e-mail address.
      attribute? :email_address_to, Types::Email

      # EmailAddressCC Customer e-mail address, Carbon copy. Must be a valid e-mail address.
      attribute? :email_address_cc, Types::Email

      # EmailAddressBCC Customer e-mail address, Blind carbon copy. Must be a valid e-mail address.
      attribute? :email_address_bcc, Types::Email

      # EmailSubject Subject of the e-mail
      attribute? :email_subject, Types::Sized::String[100]

      # EmailBody Body of the e-mail
      attribute? :email_body, Types::Sized::String[20_000]
    end
  end
end
