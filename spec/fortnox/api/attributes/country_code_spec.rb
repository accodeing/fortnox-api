require 'spec_helper'
require 'fortnox/api/attributes/country_code'

describe Fortnox::API::Attributes::CountryCode do

  class TestCase
    include Virtus.model
    include Fortnox::API::Attributes::CountryCode
  end

  describe '.new' do
    context 'with country code' do
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
