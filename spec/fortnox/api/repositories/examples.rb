shared_examples_for 'repositories' do
  describe '#save' do
    context "new #{described_class::MODEL}" do
      let( :repository ){ described_class.new }
      let( :model ){ described_class::MODEL.new( unsaved: false ) }

      before do
        # Should not make an API request in test!
        expect( repository ).not_to receive( :save_new )
        expect( repository ).not_to receive( :update_existing )
      end

      specify{ expect( repository.save( model )).to eql( true ) }
    end
  end
end
