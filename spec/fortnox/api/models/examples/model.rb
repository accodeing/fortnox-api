# rubocop:disable RSpec/DescribeClass
shared_examples_for 'a model' do |valid_hash, unique_id_attribute, value|
  describe '.unique_id' do
    let( :model ){ described_class.new( valid_hash.merge({ unique_id_attribute => value })) }

    before{ expect(model.send(unique_id_attribute)).to eq value }

    it{ expect(model.unique_id).to eq value }
  end
end
# rubocop:enable RSpec/DescribeClass
