require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/mappers/base/json_conversion'

describe Fortnox::API::Mapper::JSONConversion do
  before do
    module Test
      class ProductMapper
        include Fortnox::API::Mapper::JSONConversion
        KEY_MAP = {
          vat: 'VAT',
          url: '@url' # TODO: How to handle url attribute?
        }
        JSON_ENTITY_WRAPPER = 'Product'
        JSON_COLLECTION_WRAPPER = 'Products'
      end

      class Category < Dry::Struct
        attribute :name, 'strict.string'
        attribute :id, 'strict.string'
      end

      class Product < Dry::Struct
        attribute :url, 'strict.string'
        attribute :name, 'strict.string'
        attribute :vat, 'strict.float'
        attribute :categories, Dry::Types['coercible.array'].member( Test::Category )
      end
    end
  end

  let( :mapper ){ Test::ProductMapper.new }

  describe 'wrapped_json_hash_to_entity_hash' do
    let( :entity_hash ){ mapper.wrapped_json_hash_to_entity_hash( wrapped_json_hash ) }
    let( :category_1 ){ Category.new(name: 'car', id: '1') }
    let( :wrapped_json_hash ) do
      {
        'Product' => {
          '@url': 'someurl@example.com',
          'Name': 'Ford Mustang',
          'VAT': 30000,
          'Categories': [{ 'Name': 'car', 'ID': '1' }, { 'Name': 'fast car', 'ID': '2' }],
        }
      }
    end

    it{ p entity_hash }

    describe 'keys without mapping' do
      specify 'is converted correctly' do
        expect( entity_hash[:name] ).to eq 'Ford Mustang'
      end
    end

    describe 'keys with mapping' do
      specify 'is converted correctly' do
        expect( entity_hash[:vat] ).to eq 30000
      end

      specify 'is converted correctly' do
        expect( entity_hash[:url] ).to eq 'someurl@example.com'
      end
    end

    describe 'nested models' do
      let( :expected_nested_model_hash ) do
        [{ name: 'car', id: '1' }, { name: 'fast car', id: '2'}]
      end
      specify 'is converted correctly' do
        expect( entity_hash[:categories] ).to eq( expected_nested_model_hash )
      end
    end
  end

  describe 'wrapped_json_collection_to_entities_hash' do

  end

  describe 'entity_to_hash' do
    let( :category1 ){ Test::Category.new( name: 'Cars', id: '1' ) }
    let( :category2 ){ Test::Category.new( name: 'Fast Cars', id: '2' ) }
    let( :product ) do
      Test::Product.new( url: 'someurl@example.com',
                         name: 'Ford Mustang',
                         vat: 30000.0 ,
                         categories: [category1, category2] )
    end
    let( :keys_to_filter ){ [:url] }

    it{ p mapper.entity_to_hash( product, keys_to_filter ) }
  end
end
