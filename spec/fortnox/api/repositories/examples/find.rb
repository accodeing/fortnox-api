# rubocop:disable RSpec/DescribeClass
shared_examples_for '.find' do |searched_entity_id|
  describe '.find by id' do
    let( :find_id_1 ) do
      VCR.use_cassette( "#{ vcr_dir }/find_id_1" ){ repository.find( searched_entity_id ) }
    end

    describe 'returned object' do
      subject(:returned_object){ find_id_1 }

      it{ is_expected.to be_saved }
      it{ is_expected.not_to be_new }

      describe 'class' do
        subject{ returned_object.class }
        it { is_expected.to be described_class::MODEL }
      end

      describe 'unique id' do
        subject{ returned_object.unique_id}
        it { is_expected.to eq searched_entity_id }
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
