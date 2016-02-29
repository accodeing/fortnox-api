require 'spec_helper'
require 'fortnox/api/models/attributes/currency'

describe Fortnox::API::Model::Attribute::Currency do

  using_test_class do
    class Model
      include Virtus.model
      include Fortnox::API::Model::Attribute::Currency
    end
  end

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
