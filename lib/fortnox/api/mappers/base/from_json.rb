module Fortnox
  module API
    module Mapper
      module FromJSON

        def wrapped_json_collection_to_entities_hash( json_collection_hash )
          entities_hash = []
          json_collection_hash[ self.class::JSON_COLLECTION_WRAPPER ].each do |json_hash|
            entities_hash << json_hash_to_entity_hash( json_hash, self.class::KEY_MAP )
          end

          entities_hash
        end

        def wrapped_json_hash_to_entity_hash( json_entity_hash )
          json_hash_to_entity_hash( json_entity_hash[self.class::JSON_ENTITY_WRAPPER],
                                    self.class::KEY_MAP )
        end

        protected

          def json_hash_to_entity_hash( entity_json_hash, key_map )
            remove_nil_values( entity_json_hash )
            converted_hash = convert_hash_keys_from_json_format( entity_json_hash, key_map )
            converted_hash
          end

        private

          def convert_hash_keys_from_json_format( hash, key_map )
            hash.each_with_object( {} ) do |(key, value), json_hash|
              converted_key = convert_key_from_json( key, key_map )
              if value.respond_to?(:each)
                json_hash[ converted_key ] = convert_collection( key, value )
              else
                json_hash[ converted_key ] = value
              end
            end
          end

          def convert_collection( key, collection )
            nested_mapper = Registry[ key.downcase ]
            if collection.is_a?(::Array)
              converted_data = []
              collection.each do |value|
                converted_data << convert_hash_keys_from_json_format( value, nested_mapper::KEY_MAP )
              end
            else # Assume Hash
              converted_data = convert_hash_keys_from_json_format( collection, nested_mapper::KEY_MAP )
            end

            converted_data
          end

          def convert_key_from_json( key, key_map )
            key_map.key( key ) || default_key_from_json_transform( key )
          end

          def default_key_from_json_transform( key )
            key = key.to_s
            unless key =~ /\A[A-Z]+\z/
              key = key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2')
            end
            key.downcase.to_sym
          end

          def remove_nil_values( hash )
            hash.delete_if{ |_, value| value.nil? }
          end

      end
    end
  end
end
