require 'spec_helper'
require 'fortnox/api/mappers/base/from_json'
require 'fortnox/api/mappers/contexts/json_conversion'

describe Fortnox::API::Mapper::FromJSON do
  include_context 'JSON conversion'

  let( :mapper ){ Test::ProductMapper.new }

  describe 'wrapped_json_hash_to_entity_hash' do
    let( :entity_hash ){ mapper.wrapped_json_hash_to_entity_hash( wrapped_json_hash ) }
    let( :wrapped_json_hash ) do
      {
        'Product' => {
          '@url': 'someurl@example.com',
          'Name': 'Ford Mustang',
          'VAT': 30000,
          'Categories': [{ 'Name' => 'Cars', 'ID' => '1' }, { 'Name' => 'Fast cars', 'ID' => '2' }],
          'Designer': { 'Name' => 'John Najjar', 'ID' => '23' }
        }
      }
    end

    specify 'converts keys without mapping correctly' do
      expect( entity_hash[:name] ).to eq 'Ford Mustang'
    end

    specify 'converts keys with mapping correctly' do
      expect( entity_hash[:vat] ).to eq 30000
    end

    specify 'converts keys starting with "@" correctly'
    # do
    # expect( entity_hash[:url] ).to eq 'someurl@example.com'
    # end

    context 'with nested models' do
      let( :expected_nested_model_hash ) do
        [{ name: 'Cars', id: '1' }, { name: 'Fast cars', id: '2' }]
      end

      specify 'are converted correctly' do
        expect( entity_hash[:categories] ).to eq( expected_nested_model_hash )
      end
    end

    context 'with nested model' do
      let( :expected_nested_model_hash ){ { name: 'John Najjar', id: '23' } }

      specify 'is converted correctly' do
        expect( entity_hash[:designer] ).to eq( expected_nested_model_hash )
      end
    end
  end

  describe 'wrapped_json_collection_to_entities_hash' do
    it 'is tested'
  end
end
