shared_examples_for '.only' do |matching_filter, missing_filter|
  describe '.only' do
    def repository_only(vcr_cassette, filter)
      repository = described_class.new
      vcr_dir = repository.options.json_collection_wrapper.downcase

      VCR.use_cassette( "#{vcr_dir}/#{vcr_cassette}" ) do
        repository.only( filter )
      end
    end

    context "with no matches" do
      subject{ repository_only( 'filter_miss', missing_filter ) }

      it{ is_expected.to be_instance_of( Array ) }
      it{ is_expected.to have(0).entries }
    end

    context "with one match" do
      subject{ repository_only( 'filter_hit', matching_filter ) }

      it{ is_expected.to be_instance_of( Array ) }
      it{ is_expected.to have(1).entries }
    end

    context "with invalid filter" do
      subject do
        when_performing do
          repository_only( 'filter_invalid', 'doesntexist' )
        end
      end

      it{ is_expected.to raise_error( Fortnox::API::RemoteServerError, /ogiltigt filter/ ) }
    end
  end
end
