require 'spec_helper'
require 'fortnox/api/validators/context'
require 'fortnox/api/validators/edi_information'
require 'fortnox/api/models/edi_information'

describe Fortnox::API::Validator::EDIInformation do
  let( :model_class ){ Fortnox::API::Model::EDIInformation }

  include_context 'validator context'

  describe '.validate EDIInformation' do
    context 'with required attributes' do
      let( :model ){ model_class.new }

      it{ is_expected.to be_valid( model ) }
    end
  end
end
