shared_examples_for 'mapper' do |key_map, json_entity_wrapper, json_collection_wrapper|
  describe 'key_map' do
    subject{ mapper.key_map }
    it{ is_expected.to eq(key_map) }
  end

  describe 'json_entity_wrapper' do
    subject{ mapper.json_entity_wrapper }
    it{ is_expected.to eq(json_entity_wrapper) }
  end

  describe 'json_collection_wrapper' do
    subject{ mapper.json_collection_wrapper }
    it{ is_expected.to eq(json_collection_wrapper) }
  end
end
