# rubocop:disable RSpec/DescribeClass
shared_examples_for '.search' do |attribute_hash_key_name, value, matches|
  describe '.search' do

    describe 'search' do
      context "with no matches" do
        subject do
          VCR.use_cassette( "#{ vcr_dir }/search_miss" ) do
            repository.search( attribute_hash_key_name => 'nothing' )
          end
        end

        it{ is_expected.to be_instance_of( Array ) }
        it{ is_expected.to have(0).entries }
      end

      context "with #{matches} match(es)" do
        subject do
          VCR.use_cassette( "#{ vcr_dir }/search_by_name" ) do
            repository.search( attribute_hash_key_name => value )
          end
        end

        it{ is_expected.to be_instance_of( Array) }
        it{ is_expected.to have(matches).entries }
      end

    end
  end
end
# rubocop:enable RSpec/DescribeClass
