# rubocop:disable RSpec/DescribeClass
shared_examples_for '.find' do
  describe '.find' do
    let( :find_id ){ 1 }
    let( :find_id_1 ) do
      VCR.use_cassette( "#{ vcr_dir }/find_id_1" ){ repository.find( find_id ) }
    end

    describe '.find' do
      specify 'returns correct class' do
        expect( find_id_1.class ).to be described_class::MODEL
      end

      specify 'returns correct Customer' do
        id_attribute = described_class::MAPPER.new.send(
          :convert_key_from_json, described_class::UNIQUE_ID
        )
        expect( find_id_1.send(id_attribute).to_i ).to eq( find_id )
      end

      specify 'returned Customer is marked as saved' do
        expect( find_id_1 ).to be_saved
      end

      specify 'returned Customer is not markes as new' do
        expect( find_id_1 ).not_to be_new
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
