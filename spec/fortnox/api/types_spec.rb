require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types::CountryCode do

  using_test_class do
    class Model < Fortnox::API::Types::Model
      attribute :country_code, Fortnox::API::Types::CountryCode
    end
  end

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
