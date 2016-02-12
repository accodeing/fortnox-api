shared_examples_for 'repositories' do |model_class|
  describe '#save' do
    context "new #{model_class}" do
      let( :repository ){ described_class.new }
      let( :model ){ model_class.new( unsaved: false ) }

      before do
        # Should not make an API request in test!
        expect( repository ).not_to receive( :save_new )
        expect( repository ).not_to receive( :update_existing )
      end

      specify{ expect( repository.save( model )).to eql( true ) }
    end
  end
end
