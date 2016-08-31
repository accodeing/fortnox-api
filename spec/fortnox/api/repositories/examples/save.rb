# rubocop:disable RSpec/DescribeClass, RSpec/NamedSubject
#######################################
# SPEC IS DEPENDENT ON DEFINED ORDER!
#######################################
#
# Assumes that attribute_hash_name holds a string without restrictions.
shared_examples_for '.save' do |attribute_hash_name, required_attributes = {}|
  describe '.save' do
    let( :new_hash ) do
      required_attributes.merge( attribute_hash_name => value )
    end
    let( :new_model ){ described_class::MODEL.new( new_hash ) }
    let( :save_new ){ VCR.use_cassette( "#{ vcr_dir }/save_new" ){ subject.save( new_model ) } }
    let( :entity_wrapper ){ subject.mapper.json_entity_wrapper }
    let( :value ){ 'A value' }

    shared_examples_for 'save' do
      before do
        if model.saved?
          message = 'Test trying to save model, but already marked as saved!'
          message << " Model: #{ model.inspect }"
          fail(message)
        end
      end

      specify "includes correct #{ attribute_hash_name.inspect }" do
        response = send_request
        attribute_json_name = described_class::MAPPER.new
          .convert_key_to_json( attribute_hash_name )
        expect( response[entity_wrapper][attribute_json_name] ).to eql( value )
      end
    end

    describe 'new' do
      context 'when not saved' do
        include_examples 'save' do
          let( :model ){ new_model }
          let( :send_request ){ save_new }
        end
      end

      context "saved #{ described_class::MODEL }" do
        let( :repository ){ described_class.new }
        let( :hash ){ { unsaved: false }.merge(new_hash) }
        let( :model ){ described_class::MODEL.new( hash ) }

        before do
          # Should not make an API request in test!
          expect( repository ).not_to receive( :save_new )
          expect( repository ).not_to receive( :update_existing )
        end

        specify{ expect( repository.save( model )).to be( true ) }
      end
    end

    describe 'old (update existing)' do
      include_examples 'save' do
        let( :value ){ "Updated #{ attribute_hash_name }" }
        let( :model ) do
          new_id = save_new[entity_wrapper][subject.options.unique_id]
          new_record = VCR.use_cassette( "#{ vcr_dir }/find_new" ){ subject.find( new_id ) }
          new_record.update( attribute_hash_name => value )
        end
        let( :send_request ) do
          VCR.use_cassette( "#{ vcr_dir }/save_old" ){ subject.save( model ) }
        end
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass, RSpec/NamedSubject
