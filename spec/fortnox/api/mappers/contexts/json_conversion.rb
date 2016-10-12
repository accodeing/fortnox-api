require 'fortnox/api'
require 'fortnox/api/mappers'

shared_context 'JSON conversion' do
  before(:all) do
    module Test
      class CategoryMapper < Fortnox::API::Mapper::Base
      end
      class ProductDesignerMapper < Fortnox::API::Mapper::Base
      end
      class ProductMapper < Fortnox::API::Mapper::Base
      end
    end

    def register_mapper( mapper_sym, mapper )
      unless Fortnox::API::Registry.key? ( mapper_sym )
        Fortnox::API::Registry.register( mapper_sym, mapper )
      end
    end

    register_mapper( :category, Test::CategoryMapper)
    register_mapper( :categories, Test::CategoryMapper )
    register_mapper( :designer, Test::ProductDesignerMapper )
    register_mapper( :product, Test::ProductMapper )
  end

  before do
    module Test
      class CategoryMapper < Fortnox::API::Mapper::Base
        KEY_MAP = { id: 'ID' }.freeze
      end

      class ProductDesignerMapper < Fortnox::API::Mapper::Base
        KEY_MAP = { id: 'ID' }.freeze
      end

      class ProductMapper < Fortnox::API::Mapper::Base
        KEY_MAP = {
          vat: 'VAT',
          url: '@url' # TODO: How to handle url attribute?
        }.freeze
        JSON_ENTITY_WRAPPER = 'Product'.freeze
        JSON_COLLECTION_WRAPPER = 'Products'.freeze
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
end
