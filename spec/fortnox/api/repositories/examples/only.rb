shared_examples_for '.only' do |matching_filter, missing_filter|
  describe '.only' do
    def repository_only(vcr_cassette, filter)
      repository = described_class.new
      vcr_dir = repository.options.json_collection_wrapper.downcase

      VCR.use_cassette( "#{vcr_dir}/#{vcr_cassette}" ) do
        repository.only( filter )
      end
    end

    shared_examples '.only response' do |vcr_cassette, expected_entries|
      subject{ repository_only( vcr_cassette, filter )}

      it{ is_expected.to be_instance_of( Array ) }
      it{ is_expected.to have(expected_entries).entries }
    end

    context "with no matches" do
      include_examples '.only response', 'filter_miss', 0 do
        let(:filter){ missing_filter }
      end
    end

    context "with one match" do
      include_examples '.only response', 'filter_hit', 1 do
        let(:filter){ matching_filter }
      end
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
