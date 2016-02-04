require 'spec_helper'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/models/invoice'

describe Fortnox::API::Repository::Invoice do

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

  let( :repository ){ Fortnox::API::Repository::Invoice.new }

  describe '#save' do
    context 'unsaved, new Invoice' do
      let( :invoice ){ Fortnox::API::Model::Invoice.new( unsaved: false ) }

      it 'doesn\'t make an API request' do
        expect( repository ).not_to receive( :save_new )
        expect( repository ).not_to receive( :update_existing )
        expect( repository.save( invoice )).to eql( true )
      end
    end
  end

end
