module Fortnox
  module API
    module Mapper
      module ToJSON
        def self.included(base)
          base.instance_eval do

            def call( entity, keys_to_filter = {} )
              entity_hash = entity.to_hash
              clean_entity_hash = sanitise( entity_hash, keys_to_filter )
              clean_entity_hash = convert_hash_keys_to_json_format( clean_entity_hash )
              Registry[:hash].call( clean_entity_hash )
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

            def sanitise( hash, keys_to_filter )
              hash.select do |key, value|
                next false if keys_to_filter.include?( key )
                value != nil
              end
            end

            private_class_method :convert_hash_keys_to_json_format,
                                 :convert_key_to_json,
                                 :default_key_to_json_transform,
                                 :sanitise
          end
        end

        def entity_to_hash( entity, keys_to_filter )
          entity_json_hash = Registry[ mapper_name_for( entity ) ]
                             .call( entity, keys_to_filter )
          { self.class::JSON_ENTITY_WRAPPER => entity_json_hash }
        end

        private

          def mapper_name_for( value )
            value.class.name.split('::').last.downcase.to_sym
          end
      end
    end
  end
end
