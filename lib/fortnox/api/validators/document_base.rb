module Fortnox
  module API
    module Validator
      module DocumentBase
        def self.included(base)
          base.using_validations do
            validates_presence_of :customer_number

            validates_inclusion_of :administration_fee,  within: (0..99_999_999_999.0),       if: :administration_fee?
            validates_inclusion_of :currency_rate,       within: (0..999_999_999_999_999.0),  if: :currency_rate?
            validates_inclusion_of :currency_unit,       within: (0..999_999_999_999_999.0),  if: :currency_unit?
            validates_inclusion_of :freight,             within: (0..99_999_999_999.0),       if: :freight?

            validates_length_of :address1,                     length: 0..1024,  if: :address1?
            validates_length_of :address2,                     length: 0..1024,  if: :address2?
            validates_length_of :customer_name,                length: 0..1024,  if: :customer_name?
            validates_length_of :external_invoice_reference1,  length: 0..80,    if: :external_invoice_reference1?
            validates_length_of :external_invoice_reference2,  length: 0..80,    if: :external_invoice_reference2?
            validates_length_of :our_reference,                length: 0..50,    if: :our_reference?
            validates_length_of :phone1,                       length: 0..1024,  if: :phone1?
            validates_length_of :phone2,                       length: 0..1024,  if: :phone2?
            validates_length_of :remarks,                      length: 0..1024,  if: :remarks?
            validates_length_of :your_order_number,            length: 0..30,    if: :your_order_number?
            validates_length_of :your_reference,               length: 0..50,    if: :your_reference?
            validates_length_of :zip_code,                     length: 0..1024,  if: :zip_code?
          end
        end
      end
    end
  end
end
