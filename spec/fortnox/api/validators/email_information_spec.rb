require 'spec_helper'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/email_information'
require 'fortnox/api/models/email_information'

describe Fortnox::API::Validator::EmailInformation do
  let( :model_class ){ Fortnox::API::Model::EmailInformation }

  include_context 'validator context' do
    let( :valid_model ){ model_class.new }
  end

  describe '.validate EmailInformation' do
    context 'with required attributes' do
      it{ is_expected.to be_valid( valid_model ) }
    end

    include_examples 'validates length of string', :email_address_to, 1024
    include_examples 'validates length of string', :email_address_cc, 1024
    include_examples 'validates length of string', :email_address_bcc, 1024
    include_examples 'validates length of string', :email_subject, 100
    include_examples 'validates length of string', :email_body, 20000
  end
end
