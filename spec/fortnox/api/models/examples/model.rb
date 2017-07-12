shared_examples_for 'a model' do |valid_hash, unique_id_attribute, unique_id|
  it 'can be initialized' do
    expect{ described_class.new(valid_hash) }.not_to raise_error
  end

  describe '.unique_id' do
    let( :model ){ described_class.new( valid_hash.merge({ unique_id_attribute => unique_id })) }

    before{ expect(model.send(unique_id_attribute)).to eq unique_id }

    it{ expect(model.unique_id).to eq unique_id }
  end
end
