require 'spec_helper'
require 'fortnox/api/types/email_information'

RSpec.describe Fortnox::API::Types::EmailInformation, type: :type do
  subject{ described_class }

  it{ is_expected.to have_email( :email_address_to ) }
  it{ is_expected.to have_email( :email_address_cc ) }
  it{ is_expected.to have_email( :email_address_bcc ) }

  it{ is_expected.to have_sized_string( :email_subject, 100 ) }
  it{ is_expected.to have_sized_string( :email_body, 20000 ) }
end
