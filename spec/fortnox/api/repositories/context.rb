shared_context 'repository context' do
  before(:all){
    ENV['FORTNOX_API_BASE_URL'] = ''
    ENV['FORTNOX_API_CLIENT_SECRET'] = ''
    ENV['FORTNOX_API_ACCESS_TOKEN'] = ''
  }

  after(:all){
    ENV['FORTNOX_API_BASE_URL'] = nil
    ENV['FORTNOX_API_CLIENT_SECRET'] = nil
    ENV['FORTNOX_API_ACCESS_TOKEN'] = nil
  }

  shared_examples '#save' do |klass|
    describe '#save' do
      context "new #{klass}" do
        before do
          # Should not make an API request in test!
          expect( repository ).not_to receive( :save_new )
          expect( repository ).not_to receive( :update_existing )
        end

        specify{ expect( repository.save( model )).to eql( true ) }
      end
    end
  end
end
