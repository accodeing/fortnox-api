# rubocop:disable RSpec/DescribeClass
shared_examples_for '.only' do |matching_filter, expected_matches, missing_filter: nil|
  describe '.only' do
    def repository_only(vcr_cassette, filter)
      repository = described_class.new

      VCR.use_cassette( "#{ vcr_dir }/#{ vcr_cassette }" ) do
        repository.only( filter )
      end
    end

    shared_examples '.only response' do |vcr_cassette, expected_entries|
      subject{ repository_only( vcr_cassette, filter ) }

      it{ is_expected.to be_instance_of( Array ) }
      it{ is_expected.to have(expected_entries).entries }
    end

    unless missing_filter.nil?
      context "with no matches" do
        include_examples '.only response', 'filter_miss', 0 do
          let(:filter){ missing_filter }
        end
      end
    end

    context "with matches" do
      include_examples '.only response', 'filter_hit', expected_matches do
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
# rubocop:enable RSpec/DescribeClass
