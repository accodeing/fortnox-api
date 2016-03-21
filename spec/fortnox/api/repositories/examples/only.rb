
shared_examples_for '.only' do |matching_filter, missing_filter|
  describe '.only' do

    let( :repository ){ described_class.new }
    let( :vcr_dir ){ repository.options.json_collection_wrapper.downcase }

    context "with no matches" do
      subject do
        VCR.use_cassette( "#{vcr_dir}/filter_miss" ) do
          repository.only( missing_filter )
        end
      end

      it{ is_expected.to be_instance_of( Array ) }
      it{ is_expected.to have(0).entries }
    end

    context "with one match" do
      subject do
        VCR.use_cassette( "#{vcr_dir}/filter_hit" ) do
          repository.only( matching_filter )
        end
      end

      it{ is_expected.to be_instance_of( Array ) }
      it{ is_expected.to have(1).entries }
    end

    context "with invalid filter" do
      subject do
        when_performing do
          VCR.use_cassette( "#{vcr_dir}/filter_invalid" ) do
            repository.only( 'doesntexist' )
          end
        end
      end

      it{ is_expected.to raise_error( Fortnox::API::RemoteServerError, /ogiltigt filter/ ) }
    end
  end
end
