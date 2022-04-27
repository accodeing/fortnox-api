# frozen_string_literal: true

# Test saving model with attributes that has specially names that needs to be mapped.
#
# NOTE: VCR cassette must be discarded when repositories are updated to reflect
# the changes!
shared_examples_for '.save with specially named attribute' do |required_hash, attribute, value|
  describe '.save' do
    context 'with specially named attribute' do
      subject { -> { save_model } }

      let(:new_model) { described_class::MODEL.new(required_hash.merge(attribute => value)) }
      let(:save_model) do
        VCR.use_cassette("#{vcr_dir}/save_with_specially_named_attribute") do
          repository.save(new_model)
        end
      end

      it { is_expected.not_to raise_error }

      describe 'response' do
        subject { save_model.send(attribute) }

        it { is_expected.to eq(value) }
      end
    end
  end
end
