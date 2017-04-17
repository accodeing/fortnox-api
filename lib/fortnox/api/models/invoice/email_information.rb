class EmailInformation
  include Virtus.value_object

  values do
    #EmailAddressTo Customer e-mail address. Must be a valid e-mail address. 1024 characters
    attribute :email_address_to, String

    #EmailAddressCC Customer e-mail address – Copy. Must be a valid e-mail address. 1024 characters
    attribute :email_address_cc, String

    #EmailAddressBCC Customer e-mail address – Blind carbon copy. Must be a valid e-mail address. 1024 characters
    attribute :email_address_bcc, String

    #EmailSubject Subject of the e-mail, 100 characters. The variable {no} = document number. The variable {name} =  customer name.
    attribute :email_subject, String

    #EmailBody Body of the e-mail, 20000 characters. The variable {no}  = document number. The variable {name} =  customer name
    attribute :email_body, String
  end
end
