# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Project, order: :defined do
  let(:vcr_dir) { 'projects' }

  describe '.save' do
    let(:new_model) { described_class.stub(description: 'Some important project', comments: 'A value') }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") { described_class.save(new_model) }
    end

    describe 'new' do
      it 'saves with correct comments' do
        expect(save_new.model.comments).to eq('A value')
      end
    end

    describe 'old (update existing)' do
      let(:existing_model) do
        VCR.use_cassette("#{vcr_dir}/find_new") do
          described_class.find(save_new.model.project_number)
        end
      end

      let(:updated_model) { existing_model.update(comments: 'Updated comments') }

      let(:save_old) do
        VCR.use_cassette("#{vcr_dir}/save_old") { described_class.save(updated_model) }
      end

      it 'updates with correct comments' do
        expect(save_old.model.comments).to eq('Updated comments')
      end
    end
  end

  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { described_class.all }
    end

    it 'returns correct number of records' do
      expect(response.size).to eq 2
    end

    it 'returns correct class' do
      expect(response.first).to be_a(described_class)
    end
  end

  describe '.find' do
    describe 'by id' do
      let(:returned_object) do
        VCR.use_cassette("#{vcr_dir}/find_id_1") { described_class.find('1') }
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
          expect(returned_object.unique_id).to eq '1'
        end
      end

      context 'when not found' do
        let(:find_with_non_existing_id) do
          VCR.use_cassette("#{vcr_dir}/find_failure") { described_class.find('123456789') }
        end

        it 'raises an error' do
          expect { find_with_non_existing_id }.to raise_error(RestEasy::Error)
        end
      end
    end

    describe 'by hash' do
      context 'when found' do
        context 'with single parameter' do
          let(:returned_array) do
            VCR.use_cassette("#{vcr_dir}/single_param_find_by_hash") do
              described_class.find(limit: 1)
            end
          end

          it 'returns 1 match' do
            expect(returned_array.size).to eq 1
          end
        end

        context 'with multiple parameters' do
          let(:returned_array) do
            VCR.use_cassette("#{vcr_dir}/multi_param_find_by_hash") do
              described_class.find(limit: 2, offset: 0)
            end
          end

          it 'returns 2 matches' do
            expect(returned_array.size).to eq 2
          end
        end
      end

      context 'when not found' do
        let(:find_failure) do
          VCR.use_cassette("#{vcr_dir}/find_by_hash_failure") do
            described_class.find(offset: 10_000)
          end
        end

        it 'returns empty array' do
          expect(find_failure).to eq []
        end
      end
    end
  end
end
