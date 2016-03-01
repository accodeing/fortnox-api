require 'spec_helper'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/models/attributes/dummy_model_context'

describe Fortnox::API::Model::Attribute::CountryCode do

  include_context 'create dummy Model that includes described_class'

  describe '.new' do
    context 'with country code' do
      it 'ignores empty values' do
        test_case = Model.new()
        expect( test_case.country_code ).to eql( nil )
      end

      it 'truncates to two characters' do
        test_case = Model.new( country_code: 'sek' )
        expect( test_case.country_code ).to eql( 'SE' )
      end
    end
  end

end
