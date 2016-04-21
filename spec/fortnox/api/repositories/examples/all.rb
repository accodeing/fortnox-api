shared_examples_for '.all' do |count|
  describe '.all' do
    let(:response) do
      vcr_dir = subject.options.json_collection_wrapper.downcase
      VCR.use_cassette( "#{vcr_dir}/all" ){ subject.all }
    end

    specify 'returns correct number of records' do
      expect( response.size ).to be count
    end

    specify 'returns correct class' do
      expect( response.first.class ).to be described_class::MODEL
    end
  end
end
