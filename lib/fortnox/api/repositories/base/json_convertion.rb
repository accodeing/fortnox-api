module Fortnox
  module API
    module Repository
      module JSONConvertion

      module_function

        def hash_to_entity( entity_json_hash, key_map )
          entity_json_hash = clean_hash(entity_json_hash)
          entity_hash = convert_hash_keys_from_json_format( entity_json_hash, key_map )
          instansiate( entity_hash )
        end

        def entity_to_hash( entity, key_map, json_entity_wrapper, keys_to_filter )
          entity_hash = entity.to_hash
          clean_entity_hash = clean_hash( sanitise( entity_hash, keys_to_filter ) )
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

        # Removes nil values and empty collections recursively from Hash
        def clean_hash( hash )
          cleaned_hash = hash.select{ |k, v| v != nil }
          cleaned_hash.each do |k, v|
            cleaned_hash[k] = clean_collection( v ) if v.respond_to?( :each )
          end
        end

        def clean_collection( collection )
          case collection
          when Array
            collection = clean_array( collection )
          when Hash
            collection = clean_hash( collection )
          end
        end

        # Removes nil values and empty collections recursively from Array
        def clean_array( array )
          cleaned_array = array.select{ |e| e != nil }
          cleaned_array.each_with_index do |e, i|
            cleaned_array[i] = clean_collection( e ) if e.respond_to?( :each )
          end
        end
      end
    end
  end
end
