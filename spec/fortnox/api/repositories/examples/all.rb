# frozen_string_literal: true

RSpec.shared_examples_for '.all' do
  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { subject.all }
    end

    it 'returns a list of records' do
      expect(response).not_to be_empty
    end

    it 'returns correct class' do
      expect(response.first.class).to be described_class::MODEL
    end
  end
end
