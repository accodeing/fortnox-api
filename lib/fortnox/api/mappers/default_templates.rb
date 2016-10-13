require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class DefaultTemplates < Fortnox::API::Mapper::Base

        KEY_MAP = {}.freeze
        JSON_ENTITY_WRAPPER = JSON_COLLECTION_WRAPPER = 'DefaultTemplates'.freeze
      end

      Registry.register( DefaultTemplates.canonical_name_sym, DefaultTemplates )
    end
  end
end
