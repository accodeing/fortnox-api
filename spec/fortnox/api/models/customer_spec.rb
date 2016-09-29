require 'spec_helper'
require 'fortnox/api/models/customer'

describe Fortnox::API::Model::Customer, type: :model do

  valid_hash = { name: 'Arthur Dent' }

  subject{ described_class }

  it{ is_expected.to require_attribute( :name, valid_hash ) }
  it{ is_expected.to have_sized_float( :invoice_discount, 0.0, 99_999_999_999.0, valid_hash ) }
  it{ is_expected.to have_sized_float( :invoice_administration_fee, 0.0, 99_999_999_999.0, valid_hash ) }
  it{ is_expected.to have_sized_float( :invoice_freight, 0.0, 99_999_999_999.0, valid_hash ) }
end
