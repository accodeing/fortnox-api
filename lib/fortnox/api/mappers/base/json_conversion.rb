module Fortnox
  module API
    module Mapper
      module JSONConversion

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

        def entity_to_hash( entity, keys_to_filter )
          entity_hash = entity.to_hash
          clean_entity_hash = sanitise( entity_hash, keys_to_filter )
          entity_json_hash = Registry[ mapper_name_for( entity ) ].call( entity.to_hash )
          { self.class::JSON_ENTITY_WRAPPER => entity_json_hash }
        end

        protected

          def json_hash_to_entity_hash( entity_json_hash, key_map )
            remove_nil_values( entity_json_hash )
            converted_hash = convert_hash_keys_from_json_format( entity_json_hash, key_map )
            convert_nested_mappers_from_json_format( converted_hash ) if self.class.const_defined?('NESTED_MAPPERS')
            converted_hash
          end

        private

          def mapper_name_for( value )
            value.class.name.split('::').last.downcase.to_sym
          end

          def convert_nested_mappers_from_json_format( hash )
            nested_mappers = self.class::NESTED_MAPPERS

            nested_mappers.each do |key, mapper|
              nested_json_data = hash.fetch( key )

              if nested_json_data.is_a?(::Array) # Possibly several nested models
                hash[key] = []
                nested_json_data.each do |nested_json_hash|
                  hash[key] << mapper.json_hash_to_entity_hash( nested_json_hash, mapper.class::KEY_MAP )
                end
              else # Assume one nested model in a hash
                 hash[key] = mapper.json_hash_to_entity_hash( nested_json_data, mapper.class::KEY_MAP )
              end
            end
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
            unless key =~ /\A[A-Z]+\z/
              key = key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2')
            end
            key.downcase.to_sym
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
