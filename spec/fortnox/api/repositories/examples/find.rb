# rubocop:disable RSpec/DescribeClass
shared_examples_for '.find' do |searched_entity_id|
  describe '.find' do
    let( :find_id_1 ) do
      VCR.use_cassette( "#{ vcr_dir }/find_id_1" ){ repository.find( searched_entity_id ) }
    end

    specify 'returns correct class' do
      expect( find_id_1.class ).to be described_class::MODEL
    end

    specify 'returns correct Customer' do
      expect( find_id_1.unique_id ).to eq( searched_entity_id )
    end

    specify 'returned Customer is marked as saved' do
      expect( find_id_1 ).to be_saved
    end

    specify 'returned Customer is not markes as new' do
      expect( find_id_1 ).not_to be_new
    end
  end
end
# rubocop:enable RSpec/DescribeClass
