shared_examples_for 'mapper' do |key_map, json_entity_wrapper, json_collection_wrapper, check_constants: true|
  it{ is_expected.to respond_to(:wrapped_json_collection_to_entities_hash) }
  it{ is_expected.to respond_to(:wrapped_json_hash_to_entity_hash) }
  it{ is_expected.to respond_to(:entity_to_hash) }

  if check_constants
    describe 'key_map' do
      subject{ described_class::KEY_MAP }
      it{ is_expected.to eq(key_map) }
    end

    describe 'json_entity_wrapper' do
      subject{ described_class::JSON_ENTITY_WRAPPER }
      it{ is_expected.to eq(json_entity_wrapper) }
    end

    describe 'json_collection_wrapper' do
      subject{ described_class::JSON_COLLECTION_WRAPPER }
      it{ is_expected.to eq(json_collection_wrapper) }
    end
  end
end
