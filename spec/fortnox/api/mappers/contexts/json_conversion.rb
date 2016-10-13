require 'fortnox/api'
require 'fortnox/api/mappers'

shared_context 'JSON conversion' do
  before do
    module Test
      class BaseMapper
      end

      class CategoryMapper < BaseMapper
        KEY_MAP = { id: 'ID' }.freeze
      end

      class ProductDesignerMapper < BaseMapper
        KEY_MAP = { id: 'ID' }.freeze
      end

      class ProductMapper < BaseMapper
        KEY_MAP = {
          vat: 'VAT',
          url: '@url' # TODO: How to handle url attribute?
        }.freeze
        JSON_ENTITY_WRAPPER = 'Product'.freeze
        JSON_COLLECTION_WRAPPER = 'Products'.freeze
      end

      class Category < Fortnox::API::Model::Base
        attribute :name, 'strict.string'
        attribute :id, 'strict.string'
      end

      class ProductDesigner < Fortnox::API::Model::Base
        attribute :name, 'strict.string'
        attribute :id, 'strict.string'
      end

      class Product < Fortnox::API::Model::Base
        attribute :url, 'strict.string'
        attribute :name, 'strict.string'
        attribute :vat, 'strict.float'
        attribute :categories, Dry::Types['coercible.array'].member( Test::Category )
        attribute :designer, Test::ProductDesigner
      end
    end

    def register_mapper( mapper_sym, mapper )
      unless Fortnox::API::Registry.key? mapper_sym
        Fortnox::API::Registry.register( mapper_sym, mapper )
      end
    end

    register_mapper( :category, Test::CategoryMapper)
    register_mapper( :productdesigner, Test::ProductDesignerMapper )
    register_mapper( :product, Test::ProductMapper )
  end
end
