require 'spec_helper'
require 'fortnox/api/models/attributes/currency'

describe Fortnox::API::Model::Attribute::Currency do

  let( :model ){
    class Model
      include Virtus.model
      include Fortnox::API::Model::Attribute::Currency
    end
  }

  subject{ instance.currency }

  describe '.new' do
    context 'with empty country code' do
      let( :instance ){ model.new() }
      it{ is_expected.to eql( nil ) }
    end

    context 'with lowercase country code' do
      let( :instance ){ model.new( currency: 'sek' ) }
      it{ is_expected.to eql( 'SEK' ) }
    end

    context 'with too long country code' do
      let( :instance ){ model.new( currency: 'usdollar' ) }
      it{ is_expected.to eql( 'USD' ) }
    end

    context 'with too long country code' do
      let( :instance ){ model.new( currency: 'dollaridoos' ) }
      it{ is_expected.to eql( 'DOL' ) }
    end
  end

end
