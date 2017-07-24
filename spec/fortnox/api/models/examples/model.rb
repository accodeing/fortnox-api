shared_examples_for 'a model' do |unique_id|
  let( :required_attributes ){ described_class::STUB.dup }
  let( :unique_id_attribute ){ described_class::UNIQUE_ID }

  it 'can be initialized' do
    expect{ described_class.new( required_attributes ) }.not_to raise_error
  end

  describe '.unique_id' do
    subject{ model.unique_id }

    before{ expect(model.send(unique_id_attribute)).to eq unique_id }

    let( :attributes ){ required_attributes.merge(unique_id_attribute => unique_id) }
    let( :model ){ described_class.new( attributes ) }

    it{ is_expected.to eq unique_id }
  end
end
