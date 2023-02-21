# frozen_string_literal: true

# TODO: This will not work until we solve issue #62.
# Until then, these tests are pending.
shared_examples_for '.save with nested model' do |required_hash, nested_model_key, nested_model_hash, nested_entity|
  describe '.save with nested model' do
    let(:repository) { described_class.new }
    let(:new_hash) do
      required_hash.merge(nested_model_key => nested_entity)
    end
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/save_with_nested_model") do
        model = described_class::MODEL.new(new_hash)
        repository.save(model)
      end
    end

    describe 'returned entity\'s nested model' do
      subject(:returned_nested_model) { response.send(nested_model_key).first }

      it 'has the wanted attributes' do
        nested_model_hash.each do |attribute, value|
          expect(returned_nested_model.send(attribute)).to eq(value)
        end
      end
    end
  end
end
