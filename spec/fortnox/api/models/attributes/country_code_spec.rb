require 'spec_helper'
require 'fortnox/api/models/attributes/country_code'

describe Fortnox::API::Model::Attribute::CountryCode do

  class TestCase
    include Virtus.model
    include Fortnox::API::Model::Attribute::CountryCode
  end

  describe '.new' do
    context 'with country code' do
      it 'ignores empty values' do
        test_case = TestCase.new()
        expect( test_case.country_code ).to eql( nil )
      end

      it 'upcases lower case' do
        test_case = TestCase.new( country_code: 'se' )
        expect( test_case.country_code ).to eql( 'SE' )
      end

      it 'truncates to two characters' do
        test_case = TestCase.new( country_code: 'sek' )
        expect( test_case.country_code ).to eql( 'SE' )
      end
    end
  end

end
