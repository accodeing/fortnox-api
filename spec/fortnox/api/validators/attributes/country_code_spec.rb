require 'spec_helper'
require 'fortnox/api/models/base'
require 'fortnox/api/models/attributes/country_code'
require 'fortnox/api/validators/attributes/country_code'

describe Fortnox::API::Validator::Attribute::CountryCode do

  let( :model ){
    class Model < Fortnox::API::Model::Base
      include Fortnox::API::Model::Attribute::CountryCode
    end
  }

  let( :validator ){
    class Validator
      extend Fortnox::API::Validator::Base
      include Fortnox::API::Validator::Attribute::CountryCode
    end
  }

  describe '.validate' do
    context 'does not allow bogus country_code value' do
      let( :instance ){ model.new( country_code: 'aaa' ) }
      subject{ validator.validate( instance ) }
      it{ is_expected.to eql( false ) }
    end
  end

end
