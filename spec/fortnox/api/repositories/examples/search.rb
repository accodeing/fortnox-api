shared_examples_for '.search' do |attribute_hash_key_name, value|
  describe '.search' do

    describe 'search' do

      let( :repository ){ described_class.new }
      let( :vcr_dir ){ repository.options.json_collection_wrapper.downcase }

      context "with no matches" do
        subject do
          VCR.use_cassette( "#{ vcr_dir }/search_miss" ) do
            repository.search( attribute_hash_key_name => 'nothing' )
          end
        end

        it{ is_expected.to be_instance_of( Array) }
        it{ is_expected.to have(0).entries }
      end

      context "with one match" do
        subject do
          VCR.use_cassette( "#{ vcr_dir }/search_by_name" ) do
            repository.search( attribute_hash_key_name => value )
          end
        end

        it{ is_expected.to be_instance_of( Array) }
        it{ is_expected.to have(1).entries }
      end

    end
  end
end
