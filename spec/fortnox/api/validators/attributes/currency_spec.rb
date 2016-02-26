require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/currency'
require 'fortnox/api/validators/attributes/currency'

describe Fortnox::API::Validator::Attribute::Currency do

  let( :model ){
    class Model < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::Currency
    end
  }

  let( :validator ){
    class Validator
      extend Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::Currency
    end
  }

  describe '.validate' do
    context 'model with invalid currency attribute' do
      let( :instance ){ model.new( currency: '-_-' ) }

      it 'is invalid' do
        expect( validator.validate( instance )).to eql( false )
      end
    end
  end

end
