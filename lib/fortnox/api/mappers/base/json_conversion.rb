module Fortnox
  module API
    module Mapper
      module JSONConversion

        def wrapped_json_collection_to_entities_hash( json_collection_hash )
          entities_hash = []
          json_collection_hash[ self.class::JSON_COLLECTION_WRAPPER ].each do |json_hash|
            entities_hash << json_hash_to_entity_hash( json_hash )
          end

          entities_hash
        end

        def wrapped_json_hash_to_entity_hash( json_entity_hash )
          json_hash_to_entity_hash( json_entity_hash[self.class::JSON_ENTITY_WRAPPER] )
        end

        def entity_to_hash( entity, keys_to_filter )
          entity_hash = entity.to_hash
          clean_entity_hash = sanitise( entity_hash, keys_to_filter )
          entity_json_hash = convert_hash_keys_to_json_format( clean_entity_hash )
          { self.class::JSON_ENTITY_WRAPPER => entity_json_hash }
        end

        private

          def json_hash_to_entity_hash( entity_json_hash )
            remove_nil_values( entity_json_hash )
            convert_hash_keys_from_json_format( entity_json_hash )
          end

          def convert_hash_keys_from_json_format( hash )
            hash.each_with_object( {} ) do |(key, value), json_hash|
              json_hash[ convert_key_from_json( key ) ] = value
            end
          end

          def convert_key_from_json( key )
            self.class::KEY_MAP.fetch( key ){ default_key_from_json_transform( key ) }
          end

          def default_key_from_json_transform( key )
            key = key.to_s
            return key.downcase if key =~ /\A[A-Z]+\z/
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
            self.class::KEY_MAP.fetch( key ){ default_key_to_json_transform( key ) }
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
