require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class Unit < Fortnox::API::Mapper::Base
        KEY_MAP = {}.freeze
        JSON_ENTITY_WRAPPER = 'Unit'.freeze
        JSON_COLLECTION_WRAPPER = 'Units'.freeze
      end

      Registry.register( Unit.canonical_name_sym, Unit )
    end
  end
end
