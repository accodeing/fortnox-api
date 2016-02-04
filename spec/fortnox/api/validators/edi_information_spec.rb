require 'spec_helper'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/edi_information'
require 'fortnox/api/models/edi_information'

describe Fortnox::API::Validator::EDIInformation do
  let( :model_class ){ Fortnox::API::Model::EDIInformation }
  let( :valid_model ){ model_class.new }

  include_context 'validator context'

  describe '.validate EDIInformation' do
    context 'with required attributes' do
      it{ is_expected.to be_valid( valid_model ) }
    end
  end
end
