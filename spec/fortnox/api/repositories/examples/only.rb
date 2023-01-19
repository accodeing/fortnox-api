# frozen_string_literal: true

shared_examples_for '.only' do |matching_filter, expected_matches, missing_filter: nil|
  describe '.only' do
    shared_examples '.only response' do |vcr_cassette, expected_entries|
      subject { VCR.use_cassette("#{vcr_dir}/#{vcr_cassette}") { repository.only(filter) } }

      it { is_expected.to be_instance_of(Array) }
      it { is_expected.to have(expected_entries).entries }
    end

    unless missing_filter.nil?
      context 'with no matches' do
        include_examples '.only response', 'filter_miss', 0 do
          let(:filter) { missing_filter }
        end
      end
    end

    context 'with matches' do
      include_examples '.only response', 'filter_hit', expected_matches do
        let(:filter) { matching_filter }
      end
    end

    context 'with invalid filter' do
      let(:call_only_with_invalid_filter) do
        VCR.use_cassette("#{vcr_dir}/filter_invalid") { repository.only('doesntexist') }
      end

      specify do
        expect { call_only_with_invalid_filter }.to raise_error(Fortnox::API::RemoteServerError, /ogiltigt filter/)
      end
    end
  end
end
