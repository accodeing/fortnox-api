require 'spec_helper'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/models/attributes/dummy_model_context'

describe Fortnox::API::Model::Attribute::Currency do

  include_context 'create dummy Model that includes described_class'

  subject{ instance.currency }

  describe '.new' do
    context 'with empty country code' do
      let( :instance ){ Model.new() }
      it{ is_expected.to eql( nil ) }
    end

    context 'with too long country code' do
      let( :instance ){ Model.new( currency: 'usdollar' ) }
      it{ is_expected.to eql( 'USD' ) }
    end
  end

end
