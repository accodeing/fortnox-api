require 'spec_helper'
require 'fortnox/api/models/attributes/currency'

describe Fortnox::API::Model::Attribute::Currency do

  class TestCase
    include Virtus.model
    include Fortnox::API::Model::Attribute::Currency
  end

  describe '.new' do
    context 'with country code' do
      it 'ignores empty values' do
        test_case = TestCase.new()
        expect( test_case.currency ).to eql( nil )
      end

      it 'upcases lower case' do
        test_case = TestCase.new( currency: 'sek' )
        expect( test_case.currency ).to eql( 'SEK' )
      end

      it 'truncates to two characters' do
        test_case = TestCase.new( currency: 'usdollar' )
        expect( test_case.currency ).to eql( 'USD' )
      end
    end
  end

end
