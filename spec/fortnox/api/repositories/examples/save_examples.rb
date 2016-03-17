shared_examples_for '.save' do |attribute_hash_name|
  describe '.save' do
    let( :vcr_dir ){ subject.options.json_collection_wrapper.downcase }
    let( :find_id ){ 1 }
    let( :find_id_1 ) do
      VCR.use_cassette( "#{vcr_dir}/find_id_1" ){ subject.find( find_id ) }
    end
    let( :attribute_json_name ) do
      map_value = subject.options.attr_to_json_map[attribute_hash_name]
      camelized_value = attribute_hash_name.to_s.split('_').map(&:capitalize).join('')
      json_name = map_value || camelized_value
    end

    shared_examples_for 'save' do
      specify "include correct #{attribute_hash_name.inspect} value" do
        send_request
        entity_wrapper = subject.options.json_entity_wrapper
        expect( response[entity_wrapper][attribute_json_name] ).to eql( value )
      end
    end

    describe 'new' do
      include_examples 'save' do
        let( :send_request ) do
          valid_model = described_class::MODEL.new( model_hash )
          VCR.use_cassette( "#{vcr_dir}/save_new" ){ subject.save( valid_model ) }
        end

        let( :response ){ send_request }
      end

      context "saved #{described_class::MODEL}" do
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

    describe 'old (update existing)' do
      include_examples 'save' do
        let( :value ){ updated_value }
        let( :model ){ find_id_1.update( attribute_hash_name => value ) }

        let( :send_request ) do
          VCR.use_cassette( "#{vcr_dir}/save_old" ){ subject.save( model ) }
        end
        let( :response ){ send_request }
      end
    end
  end
end
