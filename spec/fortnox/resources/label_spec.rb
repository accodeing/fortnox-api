# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Label, order: :defined do
  let(:vcr_dir) { 'labels' }

  describe '.save' do
    # NOTE: Bump descriptions when re-recording VCR cassettes — Fortnox rejects duplicates
    let(:save_description) { 'LabelSpec5' }
    let(:new_model) { described_class.stub(description: save_description) }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") { described_class.save(new_model) }
    end

    describe 'new' do
      it 'saves with correct description' do
        expect(save_new.model.description).to eq(save_description)
      end
    end

    describe 'old (update existing)' do
      # NOTE: Bump descriptions when re-recording VCR cassettes — Fortnox rejects duplicates
      let(:update_description) { 'LabelSpec6' }

      let(:save_old) do
        updated_model = save_new.update(description: update_description)
        VCR.use_cassette("#{vcr_dir}/save_old") { described_class.save(updated_model) }
      end

      it 'updates with correct description' do
        expect(save_old.model.description).to eq(update_description)
      end
    end
  end

  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { described_class.all }
    end

    it 'returns a non-empty array' do
      expect(response).not_to be_empty
    end

    it 'returns correct class' do
      expect(response.first).to be_a(described_class)
    end
  end
end
