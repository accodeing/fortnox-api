module Fortnox
  module API
    module Repository
      module JSONConvertion

      module_function

        def hash_to_entity( entity_json_hash, key_map )
          remove_nil_values(entity_json_hash)
          entity_hash = convert_hash_keys_from_json_format( entity_json_hash, key_map )
          instansiate( entity_hash )
        end

        def entity_to_hash( entity, key_map, json_entity_wrapper, keys_to_filter )
          entity_hash = entity.to_hash
          clean_entity_hash = sanitise( entity_hash, keys_to_filter )
          entity_json_hash = convert_hash_keys_to_json_format( clean_entity_hash, key_map )
          { json_entity_wrapper => entity_json_hash }
        end

        def convert_hash_keys_from_json_format( hash, key_map )
          hash.each_with_object( {} ) do |(key, value), json_hash|
            json_hash[ convert_key_from_json( key, key_map ) ] = value
          end
        end

        def convert_key_from_json( key, key_map )
          key_map.fetch( key ){ default_key_from_json_transform( key ) }
        end

        def default_key_from_json_transform( key )
          key = key.to_s
          return key.downcase if key.match(/\A[A-Z]+\z/)
          key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z])([A-Z])/, '\1_\2').
          downcase.
          to_sym
        end

        def convert_hash_keys_to_json_format( hash, key_map )
          hash.each_with_object( {} ) do |(key, value), json_hash|
            json_hash[ convert_key_to_json( key, key_map ) ] = value
          end
        end

        def convert_key_to_json( key, key_map )
          key_map.fetch( key ){ default_key_to_json_transform( key ) }
        end

        def default_key_to_json_transform( key )
          key.to_s.split('_').map(&:capitalize).join('')
        end

        def sanitise( hash, keys_to_filter )
          hash.select do |key, value|
            next false if keys_to_filter.include?( key )
            value != nil
          end
        end

        def remove_nil_values( hash )
          hash.delete_if{ |_, value| value.nil? }
        end

      end
    end
  end
end
