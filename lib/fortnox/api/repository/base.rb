require "fortnox/api/base"
require "fortnox/api/repository/json_convertion"

module Fortnox
  module API
    module Repository
      class Base < Fortnox::API::Base

        include JSONConvertion

        def initialize( options = {} )
          super()
          @base_uri = options.fetch( :base_uri ){ '/' }
          @json_list_wrapper = options.fetch( :json_list_wrapper ){ '' }
          @json_unit_wrapper = options.fetch( :json_unit_wrapper ){ '' }
          @attr_to_json_map = options.fetch( :key_map ){ {} }
          @json_to_attr_map = @attr_to_json_map.invert
        end

        def all
          response_hash = get( @base_uri )
          entities_hash = response_hash[ @json_list_wrapper ]
          entities_hash.map do |entity_hash|
            hash_to_entity( entity_hash )
          end
        end

        def find( id_or_hash )
          return find_all_by( id_or_hash ) if id_or_hash.is_a? Hash

          id = Integer( id_or_hash )
          find_one_by( id )

        catch ArgumentError
          raise ArgumentError, "find only accepts a number or hash as argument"
        end

        def find_one_by( id )
          response_hash = get( @base_uri + id )
          entity_hash = response_hash[ @json_entity_wrapper ]
          hash_to_entity( entity_hash )
        end

        def find_all_by( hash )

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

        def convert_hash_keys_from_json_format( hash )
          hash.each_with_object( {} ) do |(key, value), json_hash|
            json_hash[ convert_key_from_json( key ) ] = value
          end
        end

        def convert_key_from_json( key )
          @json_to_attr_map.fetch( key ){ default_key_from_json_transform( key ) }
        end

        def default_key_from_json_transform( key )
          key = key.to_s
          return key.downcase if key.match(/\A[A-Z]+\z/)
          key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z])([A-Z])/, '\1_\2').
          downcase.
          to_sym
        end

        def convert_hash_keys_to_json_format( hash )
          hash.each_with_object( {} ) do |key, value, json_hash|
            json_hash[ convert_key_to_json( key ) ] = value
          end
        end

        def convert_key_to_json( key )
          @attr_to_json_map.fetch( key ){ default_key_to_json_transform( key ) }
        end

        def default_key_to_json_transform( key )
          key.to_s.split('_').map(&:capitalize).join('')
        end

      end
    end
  end
end
