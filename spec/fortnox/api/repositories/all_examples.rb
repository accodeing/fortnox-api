shared_examples_for '.all' do |model_class, cassette_dir|
  describe '.all' do
    let(:response) do
      VCR.use_cassette( "#{cassette_dir}/all" ){ subject.all }
    end

    specify 'returns correct number of records' do
      expect( response.size ).to be 1
    end

    specify 'returns correct class' do
      expect( response.first.class ).to be model_class
    end
  end
end
