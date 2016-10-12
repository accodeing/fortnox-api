module Fortnox
  module API
    module Mapper
      module ToJSON
        def self.included(base)
          base.instance_eval do

            def call( hash )
              hash = convert_hash_keys_to_json_format( hash )

              hash.each do |key, value|
                hash[key] =
                  if self::NESTED_MAPPERS.key?( key )
                    delegate_to_nested_mapper( key, value )
                  else
                    convert_value_to_json_format( value )
                  end
              end
            end

            def convert_hash_keys_to_json_format( hash )
              hash.each_with_object( {} ) do |(key, value), json_hash|
                json_hash[ convert_key_to_json( key ) ] = value
              end
            end

            def convert_key_to_json( key )
              self::KEY_MAP.fetch( key ){ default_key_to_json_transform( key ) }
            end

            def default_key_to_json_transform( key )
              key.to_s.split('_').map(&:capitalize).join('')
            end

            def delegate_to_nested_mapper( key, nested_data )
              nested_mapper = self::NESTED_MAPPERS.fetch( key )

              if nested_data.is_a?( ::Array )
                nested_data.each_with_object( [] ) do |nested_model, array|
                  array << nested_mapper.call( nested_model )
                end
              else # Hash assumed
                nested_mapper.call( nested_data )
              end
            end

            def convert_value_to_json_format( value )
              Fortnox::API::Registry[ canonical_name_sym( value ) ].call( value )
            end

            private_class_method :convert_hash_keys_to_json_format,
                                 :convert_key_to_json,
                                 :default_key_to_json_transform,
                                 :delegate_to_nested_mapper,
                                 :convert_value_to_json_format
          end
        end

        def entity_to_hash( entity, keys_to_filter )
          entity_hash = entity.to_hash
          clean_entity_hash = sanitise( entity_hash, keys_to_filter )
          entity_json_hash = Registry[ mapper_name_for( entity ) ].call( entity.to_hash )
          { self.class::JSON_ENTITY_WRAPPER => entity_json_hash }
        end
      end
    end
  end
end
