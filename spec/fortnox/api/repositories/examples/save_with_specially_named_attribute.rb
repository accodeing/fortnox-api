# Test saving model with attributes that has specially names that needs to be mapped.
#
# NOTE: VCR cassette must be discarded when repositories are updated to reflect
# the changes!
shared_examples_for '.save with specially named attribute' do |attributes, attribute_name, json_name|
  describe '.save' do
    context 'with specially named attribute' do
      let( :new_model ){ described_class::MODEL.new( attributes ) }
      let( :repository ){ described_class.new }
      let( :save_model )do
        VCR.use_cassette( "#{vcr_dir}/save_with_specially_named_attribute" ) do
            repository.save( new_model )
        end
      end

      subject{ ->{ save_model } }

      it{ is_expected.to_not raise_error }

      describe 'response' do
        subject{ save_model[repository.mapper.json_entity_wrapper] }
        it{ is_expected.to include(json_name => attributes[attribute_name]) }
      end
    end
  end
end
