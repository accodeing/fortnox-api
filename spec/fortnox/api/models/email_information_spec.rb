require 'spec_helper'
require 'fortnox/api/models/email_information'

RSpec.describe Fortnox::API::Model::EmailInformation, type: :model do
  valid_hash = {}

  subject{ described_class }

  it{ is_expected.to have_email( :email_address_to, valid_hash ) }
  it{ is_expected.to have_email( :email_address_cc, valid_hash ) }
  it{ is_expected.to have_email( :email_address_bcc, valid_hash ) }

  it{ is_expected.to have_sized_string( :email_subject, 100, valid_hash ) }
  it{ is_expected.to have_sized_string( :email_body, 20000, valid_hash ) }
end
