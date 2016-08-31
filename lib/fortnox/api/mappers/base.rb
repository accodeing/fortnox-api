require "fortnox/api/mappers/base/json_conversion"

module Fortnox
  module API
    module Mapper
      class Base
        include JSONConversion

        attr_reader :key_map, :json_entity_wrapper, :json_collection_wrapper

        def initialize( key_map, json_entity_wrapper, json_collection_wrapper )
          @key_map = key_map.freeze
          @json_entity_wrapper = json_entity_wrapper.freeze
          @json_collection_wrapper = json_collection_wrapper.freeze
        end
      end
    end
  end
end
