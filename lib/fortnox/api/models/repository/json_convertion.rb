module Fortnox
  module API
    module Repository
      module JSONConvertion

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
          hash.each_with_object( {} ) do |(key, value), json_hash|
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
