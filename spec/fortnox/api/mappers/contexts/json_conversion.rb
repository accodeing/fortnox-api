# frozen_string_literal: true

require 'fortnox/api'
require 'fortnox/api/mappers'
require 'dry/container/stub'

shared_context 'with JSON conversion' do
  before do
    Fortnox::API::Registry.enable_stubs!

    stub_const('Test::BaseMapper', Class.new)

    stub_const('Test::CategoryMapper', Class.new(Test::BaseMapper))
    stub_const('Test::CategoryMapper::KEY_MAP', { id: 'ID' }.freeze)

    stub_const('Test::ProductDesignerMapper', Class.new(Test::BaseMapper))
    stub_const('Test::ProductDesignerMapper::KEY_MAP', { id: 'ID' }.freeze)

    stub_const('Test::ProductMapper', Class.new(Test::BaseMapper))
    stub_const(
      'Test::ProductMapper::KEY_MAP',
      {
        vat: 'VAT',
        url: '@url' # TODO: How to handle url attribute?
      }.freeze
    )
    stub_const('Test::ProductMapper::JSON_ENTITY_WRAPPER', 'Product')
    stub_const('Test::ProductMapper::JSON_COLLECTION_WRAPPER', 'Products')

    stub_const(
      'Test::Category',
      Class.new(Fortnox::API::Model::Base) do
        attribute :name, 'strict.string'
        attribute :id, 'strict.string'
      end
    )

    stub_const(
      'Test::ProductDesigner',
      Class.new(Fortnox::API::Model::Base) do
        attribute :name, 'strict.string'
        attribute :id, 'strict.string'
      end
    )

    stub_const(
      'Test::Product',
      Class.new(Fortnox::API::Model::Base) do
        attribute :url, 'strict.string'
        attribute :name, 'strict.string'
        attribute :vat, 'strict.float'
        attribute :categories, Dry::Types['coercible.array'].of(Test::Category)
        attribute :designer, Test::ProductDesigner
      end
    )

    def register_mapper(mapper_sym, mapper)
      unless Fortnox::API::Registry.key? mapper_sym
        # Only register the key once...
        Fortnox::API::Registry.register(mapper_sym) { mapper }
      end

      # ... but stub the value each test run
      Fortnox::API::Registry.stub(mapper_sym, mapper)
    end

    register_mapper(:category, Test::CategoryMapper)
    register_mapper(:productdesigner, Test::ProductDesignerMapper)
    register_mapper(:product, Test::ProductMapper)
  end
end
