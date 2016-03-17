shared_examples_for '.save' do |cassette_dir, entity_wrapper, attribute, fortnox_attribute|
  describe '.save' do
    let( :find_id ){ 1 }
    let( :find_id_1 ) do
      VCR.use_cassette( "#{cassette_dir}/find_id_1" ){ subject.find( find_id ) }
    end

    shared_examples_for 'save' do
      specify "include correct #{fortnox_attribute.inspect} value" do
        send_request
        expect( response[entity_wrapper][fortnox_attribute] ).to eql( value )
      end
    end

    describe 'new' do
      include_examples 'save' do
        let( :value ){ attribute_value }

        let( :send_request ) do
          VCR.use_cassette( "#{cassette_dir}/save_new" ){ subject.save( valid_model ) }
        end

        let( :response ){ send_request }
      end
    end

    describe 'old (update existing)' do
      include_examples 'save' do
        let( :value ){ updated_attribute_value }
        let( :model ){ find_id_1.update( attribute => value ) }

        let( :send_request ) do
          VCR.use_cassette( "#{cassette_dir}/save_old" ){ subject.save( model ) }
        end
        let( :response ){ send_request }
      end
    end
  end
end
