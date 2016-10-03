require 'spec_helper'
require 'fortnox/api/models/customer'

describe Fortnox::API::Model::Customer, type: :model do

  valid_hash = { name: 'Arthur Dent' }

  subject{ described_class }

  it{ is_expected.to require_attribute( :name, valid_hash ) }

  it{ is_expected.to have_sized_float( :invoice_discount, 0.0, 99_999_999_999.0, valid_hash ) }
  it{ is_expected.to have_sized_float( :invoice_administration_fee, 0.0, 99_999_999_999.0, valid_hash ) }
  it{ is_expected.to have_sized_float( :invoice_freight, 0.0, 99_999_999_999.0, valid_hash ) }

  it{ is_expected.to have_sized_string( :address1, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :address2, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :city, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :comments, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :customer_number, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_address1, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_address2, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_city, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_fax, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_name, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_phone1, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_phone2, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_zip_code, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_invoice, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_invoice_bcc, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_invoice_cc, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_offer, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_offer_bcc, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_offer_cc, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_order, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_order_bcc, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_order_cc, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :fax, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :invoice_remark, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :name, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :organisation_number, 30, valid_hash ) }
  it{ is_expected.to have_sized_string( :our_reference, 50, valid_hash ) }
  it{ is_expected.to have_sized_string( :phone1, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :phone2, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :visiting_address, 128, valid_hash ) }
  it{ is_expected.to have_sized_string( :visiting_city, 128, valid_hash ) }
  it{ is_expected.to have_sized_string( :visiting_zip_code, 10, valid_hash ) }
  it{ is_expected.to have_sized_string( :your_reference, 50, valid_hash ) }
  it{ is_expected.to have_sized_string( :zip_code, 10, valid_hash ) }

  it{ is_expected.to have_customer_type( :type, valid_hash ) }
  it{ is_expected.to have_currency( :currency, valid_hash ) }
end
