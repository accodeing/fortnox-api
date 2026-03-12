# frozen_string_literal: true

module Fortnox
  module Types
    class EmailInformation < Dry::Struct
      transform_keys do |key|
        RestEasy::Conventions::PascalCase.new.parse(key)
      end

      # EmailAddressTo Customer e-mail address. Must be a valid e-mail address. 1024 characters
      attribute? :email_address_to, Email

      # EmailAddressCC Customer e-mail address, Carbon copy. Must be a valid e-mail address. 1024 characters
      attribute? :email_address_cc, Email

      # EmailAddressBCC Customer e-mail address, Blind carbon copy. Must be a valid e-mail address. 1024 characters
      attribute? :email_address_bcc, Email

      # EmailSubject Subject of the e-mail, 100 characters.
      attribute? :email_subject, Sized::String[100]

      # EmailBody Body of the e-mail, 20000 characters.
      attribute? :email_body, Sized::String[20_000]
    end
  end
end
