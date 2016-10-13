require 'spec_helper'
require 'fortnox/api/mappers/base/to_json'
require 'fortnox/api/mappers/contexts/json_conversion'

describe Fortnox::API::Mapper::ToJSON do
  include_context 'JSON conversion'

  before do
    module Test
      class BaseMapper
        include Fortnox::API::Mapper::ToJSON
      end
    end
  end

  let( :mapper ){ Test::ProductMapper.new }

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
    let( :returned_hash ){ mapper.entity_to_hash( product, keys_to_filter ) }
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
        [{"Name" => "Cars", "ID" => "1"}, {"Name" => "Fast Cars", "ID" => "2"}]
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
