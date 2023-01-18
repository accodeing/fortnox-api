# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/unit'
require 'fortnox/api/models/unit'
require 'fortnox/api/mappers/examples/mapper'

module Fortnox
  module API
    module Mapper
      describe Unit do
        context 'when mapping model' do
          let(:model) { Model::Unit.new(code: 'lbs', description: 'Pounds') }
          let(:serialised_model_hash) { { 'Unit' => { 'Code' => 'lbs', 'Description' => 'Pounds' } } }
          let(:model_hash) { { code: 'lbs', description: 'Pounds' } }

          describe '#entity_to_hash' do
            subject { described_class.new.entity_to_hash(model, {}) }

            it { is_expected.to eq(serialised_model_hash) }
          end

          describe '#wrapped_json_hash_to_entity_hash' do
            subject { described_class.new.wrapped_json_hash_to_entity_hash(serialised_model_hash) }

            it { is_expected.to eq(model_hash) }
          end
        end

        context 'when mapping collection' do
          let(:serialised_collection_hash) do
            { 'Units' => [
              { 'Unit' => { 'Code' => 'lbs', 'Description' => 'Pounds' } },
              { 'Unit' => { 'Code' => 'ohm', 'Description' => 'Ω' } },
              { 'Unit' => { 'Code' => 'A/V', 'Description' => 'Ampere volt' } }
            ] }
          end
          let(:collection_hash) do
            [
              { unit: { code: 'lbs', description: 'Pounds' } },
              { unit: { code: 'ohm', description: 'Ω' } },
              { unit: { code: 'A/V', description: 'Ampere volt' } }
            ]
          end

          describe '#wrapped_json_collection_to_entities_hash' do
            subject { described_class.new.wrapped_json_collection_to_entities_hash(serialised_collection_hash) }

            it { is_expected.to eq(collection_hash) }
          end
        end
      end
    end
  end
end
