# TODO: This will not work until we solve issue #62.
# Until then, these tests are pending.
shared_examples_for '.save with nested model' do |required_hash, nested_key, nested_hash|
  let( :repository ){ described_class.new }
  let( :new_hash ) do
    required_hash.merge( nested_key => nested_hash )
  end
  let( :response ) do
    VCR.use_cassette( "#{ vcr_dir }/save_with_nested_model" ) do
      model = described_class::MODEL.new( new_hash )
      repository.save( model )
    end
  end

  it 'does not raise any errors' # do
    # expect{ response }.to_not raise_error
  # end

  describe 'response' do
    subject{ response }

    it 'includes correct attributes'
  end
end
