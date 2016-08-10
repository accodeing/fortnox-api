require "fortnox/api/types"

module Fortnox
  module API
    module Model
      class EmailInformation < Types::Model

        #EmailAddressTo Customer e-mail address. Must be a valid e-mail address. 1024 characters
        attribute :email_address_to, Types::Nullable::String

        #EmailAddressCC Customer e-mail address – Copy. Must be a valid e-mail address. 1024 characters
        attribute :email_address_cc, Types::Nullable::String

        #EmailAddressBCC Customer e-mail address – Blind carbon copy. Must be a valid e-mail address. 1024 characters
        attribute :email_address_bcc, Types::Nullable::String

        #EmailSubject Subject of the e-mail, 100 characters. The variable {no} = document number. The variable {name} =  customer name.
        attribute :email_subject, Types::Nullable::String

        #EmailBody Body of the e-mail, 20000 characters. The variable {no}  = document number. The variable {name} =  customer name
        attribute :email_body, Types::Nullable::String
      end
    end
  end
end
