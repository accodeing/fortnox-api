class EDIInformation
  include Virtus.value_object

  values do
    #EDIGlobalLocationNumber Invoice address GLN for EDI
    attribute :edi_global_location_number, String

    #EDIGlobalLocationNumberDelivery Delivery address GLN for EDI
    attribute :edi_global_location_number_delivery, String

    #EDIInvoiceExtra1 Extra EDI Information
    attrubte :edi_invoice_extra1, String

    #EDIInvoiceExtra2 Extra EDI Information
    attrubte :edi_invoice_extra2, String

    #EDIOurElectronicReference Our electronic reference for EDI
    attrubte :edi_our_electronic_reference, String

    #EDIYourElectronicReference Your electronic reference for EDI
    attrubte :edi_your_electronic_reference, String
  end
end
