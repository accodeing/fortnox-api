require 'spec_helper'
require 'fortnox/api/attributes/currency'

describe Fortnox::API::Attributes::Currency do

  class TestCase
    include Virtus.model
    include Fortnox::API::Attributes::Currency
  end

  describe '.new' do
    context 'with country code' do
      it 'upcases lower case' do
        test_case = TestCase.new( currency: 'sek' )
        expect( test_case.currency ).to eql( 'SEK' )
      end

      it 'truncates to two characters' do
        test_case = TestCase.new( currency: 'svenska kronor' )
        expect( test_case.currency ).to eql( 'SVE' )
      end
    end
  end

end
