require 'spec_helper'
require 'fortnox/api/models/customer/repository'
require 'fortnox/api/models/customer/entity'

describe Fortnox::API::Repositories::Customer do

  before {
    ENV['FORTNOX_API_BASE_URL'] = ''
    ENV['FORTNOX_API_CLIENT_SECRET'] = ''
    ENV['FORTNOX_API_ACCESS_TOKEN'] = ''
  }

  after {
    ENV['FORTNOX_API_BASE_URL'] = nil
    ENV['FORTNOX_API_CLIENT_SECRET'] = nil
    ENV['FORTNOX_API_ACCESS_TOKEN'] = nil
  }

  let( :repository ){ Fortnox::API::Repositories::Customer.new }

  describe '#save' do
    context 'unsaved, new customer' do
      let( :customer ){ Fortnox::API::Enteties::Customer.new( unsaved: false ) }

      it 'doesn\'t make an API request' do
        expect( repository ).not_to receive( :save_new )
        expect( repository ).not_to receive( :update_existing )
        expect( repository.save( customer )).to eql( true )
      end
    end
  end

end
