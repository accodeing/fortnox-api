# frozen_string_literal: true

require 'rest_easy/model'

module Fortnox
  module Types
    class EmailInformationClass < RestEasy::Model
      # EmailAddressTo Customer e-mail address. Must be a valid e-mail address. 1024 characters
      attribute? :email_address_to, Types::Email

      # EmailAddressCC Customer e-mail address, Carbon copy. Must be a valid e-mail address. 1024 characters
      attribute? :email_address_cc, Types::Email

      # EmailAddressBCC Customer e-mail address, Blind carbon copy. Must be a valid e-mail address. 1024 characters
      attribute? :email_address_bcc, Types::Email

      # EmailSubject Subject of the e-mail, 100 characters.
      attribute? :email_subject, Types::Sized::String[100]

      # EmailBody Body of the e-mail, 20000 characters.
      attribute? :email_body, Types::Sized::String[20_000]
    end

    EmailInformation = Types.Constructor( EmailInformationClass )
  end
end
