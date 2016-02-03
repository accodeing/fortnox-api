require 'spec_helper'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/email_information'
require 'fortnox/api/models/email_information'

describe Fortnox::API::Validator::EmailInformation do
  let( :model_class ){ Fortnox::API::Model::EmailInformation }

  include_context 'validator context'

  describe '.validate EmailInformation' do
    context 'with required attributes' do
      let( :model ){ model_class.new }

      it{ is_expected.to be_valid( model ) }
    end

    context 'with valid attributes' do
      it_behaves_like 'valid', :email_address_to, ['', 'a', 'a' * 1024]
      it_behaves_like 'valid', :email_address_cc, ['', 'a', 'a' * 1024]
      it_behaves_like 'valid', :email_address_bcc, ['', 'a', 'a' * 1024]
      it_behaves_like 'valid', :email_subject, ['', 'a', 'a' * 100]
      it_behaves_like 'valid', :email_body, ['', 'a', 'a' * 20000]
    end

    context 'with invalid attributes' do
      it_behaves_like 'invalid', :email_address_to, ['a' * 1025], :length
      it_behaves_like 'invalid', :email_address_cc, ['a' * 1025], :length
      it_behaves_like 'invalid', :email_address_bcc, ['a' * 1025], :length
      it_behaves_like 'invalid', :email_subject, ['a' * 101], :length
      it_behaves_like 'invalid', :email_body, ['a' * 20001], :length
    end
  end
end
