require "fortnox/api/base"
require "fortnox/api/repository/json_convertion"
require "fortnox/api/repository/finders"

module Fortnox
  module API
    module Repository
      class Base < Fortnox::API::Base

        include JSONConvertion
        include Finders

        def initialize( options = {} )
          super()
          @base_uri = options.fetch( :base_uri ){ '/' }
          @json_list_wrapper = options.fetch( :json_list_wrapper ){ '' }
          @json_unit_wrapper = options.fetch( :json_unit_wrapper ){ '' }
          @attr_to_json_map = options.fetch( :key_map ){ {} }
          @json_to_attr_map = @attr_to_json_map.invert
        end

        def save( customer )
          entity_to_hash( customer )
        end

      private

        def hash_to_entity( entity_json_hash )
          entity_hash = convert_hash_keys_from_json_format( entity_json_hash )
          instansiate( entity_hash )
        end

        def entity_to_hash( entity )
          entity_hash = entity.to_hash
          entity_json_hash = convert_hash_keys_to_json_format( entity_hash )
          { @json_unit_wrapper => entity_json_hash }
        end

      end
    end
  end
end
