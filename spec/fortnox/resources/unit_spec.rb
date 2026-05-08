# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Unit, order: :defined do
  let(:vcr_dir) { 'units' }

  # NOTE: Bump code when re-recording VCR cassettes — Fortnox rejects duplicates
  let(:code) { 'blarg21' }

  describe '.save' do
    let(:new_model) { described_class.stub(code: code, description: 'A value') }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") { described_class.save(new_model) }
    end

    describe 'new' do
      it 'saves with correct description' do
        expect(save_new.model.description).to eq('A value')
      end
    end

    describe 'old (update existing)' do
      let(:existing_model) do
        VCR.use_cassette("#{vcr_dir}/find_new") do
          described_class.find(save_new.model.code)
        end
      end

      let(:save_old) do
        updated_model = existing_model.update(description: 'Updated description')
        VCR.use_cassette("#{vcr_dir}/save_old") { described_class.save(updated_model) }
      end

      it 'updates with correct description' do
        expect(save_old.model.description).to eq('Updated description')
      end
    end
  end

  describe '.save with code' do
    # NOTE: Bump code when re-recording VCR cassettes — Fortnox rejects duplicates
    let(:new_model) { described_class.stub(code: 'woooh21', description: 'Happy clouds') }
    let(:save_model) do
      VCR.use_cassette("#{vcr_dir}/save_with_specially_named_attribute") do
        described_class.save(new_model)
      end
    end

    it 'does not raise any errors' do
      expect { save_model }.not_to raise_error
    end

    it 'returns the correct value' do
      expect(save_model.model.code).to eq('woooh21')
    end
  end

  describe '.save with all writable attributes' do
    # NOTE: Bump code when re-recording VCR cassettes — Fortnox rejects duplicates
    let(:fully_populated_code) { 'full1' }
    let(:writable_attributes) do
      {
        code: fully_populated_code,
        description: 'A fully populated unit',
        code_english: 'fully-populated'
      }
    end
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new_fully_populated") do
        described_class.save(described_class.stub(**writable_attributes))
      end
    end

    it 'round-trips every writable attribute', :aggregate_failures do
      writable_attributes.each do |attribute, value|
        expect(save_new.model.send(attribute)).to eq(value)
      end
    end
  end

  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { described_class.all }
    end

    it 'returns a non-empty collection' do
      expect(response).not_to be_empty
    end

    it 'returns correct class' do
      expect(response.first).to be_a(described_class)
    end
  end

  describe '.find' do
    describe 'by id' do
      let(:returned_object) do
        VCR.use_cassette("#{vcr_dir}/find_by_id") { described_class.find(code) }
      end

      context 'when found' do
        it 'is saved' do
          expect(returned_object.meta).to be_saved
        end

        it 'is not new' do
          expect(returned_object.meta).not_to be_new
        end

        it 'returns correct class' do
          expect(returned_object).to be_a(described_class)
        end

        it 'returns correct unique id' do
          expect(returned_object.unique_id).to eq code
        end
      end

      context 'when not found' do
        let(:find_with_non_existing_id) do
          VCR.use_cassette("#{vcr_dir}/find_failure") { described_class.find('123456789') }
        end

        it 'raises an error' do
          expect { find_with_non_existing_id }.to raise_error(Fortnox::RequestError)
        end
      end
    end
  end
end
