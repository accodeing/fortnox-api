require 'spec_helper'
require 'fortnox/api/repositories/customer'
require 'fortnox/api/models/customer'

describe Fortnox::API::Repository::Customer do

  before{
    ENV['FORTNOX_API_BASE_URL'] = ''
    ENV['FORTNOX_API_CLIENT_SECRET'] = ''
    ENV['FORTNOX_API_ACCESS_TOKEN'] = ''
  }

  after{
    ENV['FORTNOX_API_BASE_URL'] = nil
    ENV['FORTNOX_API_CLIENT_SECRET'] = nil
    ENV['FORTNOX_API_ACCESS_TOKEN'] = nil
  }

  let( :repository ){ Fortnox::API::Repository::Customer.new }

  describe '#save' do
    context 'unsaved, new customer' do
      let( :customer ){ Fortnox::API::Model::Customer.new( unsaved: false ) }

      it 'doesn\'t make an API request' do
        expect( repository ).not_to receive( :save_new )
        expect( repository ).not_to receive( :update_existing )
        expect( repository.save( customer )).to eql( true )
      end
    end
  end

end
