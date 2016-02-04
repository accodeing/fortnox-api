require 'spec_helper'
require 'fortnox/api/repositories/context'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/models/invoice'

describe Fortnox::API::Repository::Invoice do

  include_context 'repository context'

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
