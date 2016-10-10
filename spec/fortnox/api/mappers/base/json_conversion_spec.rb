require 'spec_helper'
require 'dry-struct'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/mappers/base/json_conversion'

describe Fortnox::API::Mapper::JSONConversion do
  before do
    module Test
      class BaseMapper
        include Fortnox::API::Mapper::JSONConversion
      end

      class CategoryMapper < BaseMapper
        KEY_MAP = { id: 'ID' }
      end

      class ProductDesignerMapper < BaseMapper
        KEY_MAP = { id: 'ID' }
      end

      class ProductMapper < BaseMapper
        KEY_MAP = {
          vat: 'VAT',
          url: '@url' # TODO: How to handle url attribute?
        }
        JSON_ENTITY_WRAPPER = 'Product'
        JSON_COLLECTION_WRAPPER = 'Products'
        NESTED_MAPPERS = {
          categories: CategoryMapper.new,
          designer: ProductDesignerMapper.new
        }
      end

      class Category < Dry::Struct
        attribute :name, 'strict.string'
        attribute :id, 'strict.string'
      end

      class ProductDesigner < Dry::Struct
        attribute :name, 'strict.string'
        attribute :id, 'strict.string'
      end

      class Product < Dry::Struct
        attribute :url, 'strict.string'
        attribute :name, 'strict.string'
        attribute :vat, 'strict.float'
        attribute :categories, Dry::Types['coercible.array'].member( Test::Category )
        attribute :designer, Test::ProductDesigner
      end
    end
  end

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
        [{ name: 'Cars', id: '1' }, { name: 'Fast cars', id: '2'}]
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

  end

  describe 'entity_to_hash' do
    let( :category1 ){ Test::Category.new( name: 'Cars', id: '1' ) }
    let( :category2 ){ Test::Category.new( name: 'Fast Cars', id: '2' ) }
    let( :product_designer ){ Test::ProductDesigner.new( name: 'John Najjar', id: '23' ) }
    let( :product ) do
      Test::Product.new( url: 'someurl@example.com',
                         name: 'Ford Mustang',
                         vat: 30000.0 ,
                         categories: [category1, category2],
                         designer: product_designer )
    end
    let( :keys_to_filter ){ [:url] }
    let( :returned_hash ) { mapper.entity_to_hash( product, keys_to_filter ) }
    let( :inner_hash ){ returned_hash['Product'] }

    it 'includes JSON entity wrapper' do
      expect( returned_hash ).to have_key( 'Product' )
    end

    context 'with keys without mapping' do
      specify 'converts correctly' do
        expect( inner_hash['Name'] ).to eq( 'Ford Mustang' )
      end
    end

    context 'with keys to filter' do
      specify 'filteres out those keys' do
        expect( inner_hash ).not_to have_key( '@url' )
      end
    end

    context 'with nested models' do
      let( :expected_nested_model_hash ) do
        [{ 'Name' => 'Cars', 'ID' => '1' }, { 'Name' => 'Fast Cars', 'ID' => '2' }]
      end

      specify 'are converted correctly' do
        expect( inner_hash['Categories'] ).to eq( expected_nested_model_hash )
      end
    end

    context 'with nested model' do
      let( :expected_nested_model_hash ){ { 'Name' => 'John Najjar', 'ID' => '23' } }

      specify 'is converted correctly' do
        expect( inner_hash['Designer'] ).to eq( expected_nested_model_hash )
      end
    end
  end
end