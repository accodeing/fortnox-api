# frozen_string_literal: true

module Fortnox
  module Structs
    class EmailInformation < Fortnox::Struct
      using RestEasy::Refinements

      # EmailAddressTo Customer e-mail address. Must be a valid e-mail address. 1024 characters
      attr :email_address_to, Types::Email

      # EmailAddressCC Customer e-mail address, Carbon copy. Must be a valid e-mail address. 1024 characters
      attr :email_address_cc <=> 'EmailAddressCC', Types::Email

      # EmailAddressBCC Customer e-mail address, Blind carbon copy. Must be a valid e-mail address. 1024 characters
      attr :email_address_bcc <=> 'EmailAddressBCC', Types::Email

      # EmailSubject Subject of the e-mail, 100 characters.
      attr :email_subject, Types::Sized::String[100]

      # EmailBody Body of the e-mail, 20000 characters.
      attr :email_body, Types::Sized::String[20_000]
    end
  end
end
