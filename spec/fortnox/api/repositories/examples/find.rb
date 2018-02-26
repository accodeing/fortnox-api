# frozen_string_literal: true

shared_examples_for '.find' do |searched_entity_id|
  describe '.find by id' do
    let(:returned_object) do
      VCR.use_cassette("#{vcr_dir}/find_id_1") { repository.find(searched_entity_id) }
    end

    context 'when found' do
      describe 'returned object' do
        subject { returned_object }

        it { is_expected.to be_saved }
        it { is_expected.not_to be_new }
      end

      describe 'class' do
        subject { returned_object.class }

        it { is_expected.to be described_class::MODEL }
      end

      describe 'unique id' do
        subject { returned_object.unique_id }

        it { is_expected.to eq searched_entity_id }
      end
    end

    context 'when not found' do
      subject { find_failure }

      let(:not_found_id) { '123456789' }
      let(:find_failure) do
        when_performing do
          VCR.use_cassette("#{vcr_dir}/find_failure") { repository.find(not_found_id) }
        end
      end

      it { is_expected.to raise_error(Fortnox::API::RemoteServerError, /Kan inte hitta /) }
    end
  end

  describe '.find by hash' do
    context 'when found' do
      let(:returned_array) do
        VCR.use_cassette("#{vcr_dir}/#{cassette}") { repository.find(find_hash) }
      end

      context 'with single parameter' do
        let(:cassette) { 'single_param_find_by_hash' }
        let(:find_hash) { single_param_find_by_hash[:find_hash] }

        describe 'returned array size' do
          subject { returned_array.size }

          it { is_expected.to eq single_param_find_by_hash[:matches] }
        end
      end

      context 'with multiple parameters' do
        let(:cassette) { 'multi_param_find_by_hash' }
        let(:find_hash) { multi_param_find_by_hash[:find_hash] }

        describe 'returned array size' do
          subject { returned_array.size }

          it { is_expected.to eq multi_param_find_by_hash[:matches] }
        end
      end
    end

    context 'when not found' do
      subject { find_failure }

      let(:find_failure) do
        VCR.use_cassette("#{vcr_dir}/find_by_hash_failure") do
          repository.find(find_by_hash_failure)
        end
      end

      it { is_expected.to eq [] }
    end
  end
end
