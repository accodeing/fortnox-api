require "fortnox/api/repositories/base"
require "fortnox/api/models/invoice"
require "fortnox/api/mappers/invoice"

module Fortnox
  module API
    module Repository
      class Invoice < Fortnox::API::Repository::Base

        CONFIGURATION = Fortnox::API::Repository::Base::Options.new(
          uri: '/invoices/',
          json_collection_wrapper: 'Invoices',
          json_entity_wrapper: 'Invoice',
          unique_id: 'DocumentNumber',
          keys_filtered_on_save: [
            :url,
          ]
        )
        MODEL = Fortnox::API::Model::Invoice
        MAPPER = Fortnox::API::Mapper::Invoice

        def initialize
          super( CONFIGURATION )
        end
      end
    end
  end
end
