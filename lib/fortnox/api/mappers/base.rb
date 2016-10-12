require "fortnox/api/mappers/base/json_conversion"

module Fortnox
  module API
    module Mapper
      class Base
        include JSONConversion

        Hash = ->(value) do
          pairs = value.inject([]) do |pairs,(k,v)|
            name = Fortnox::API::Mapper::Base.canonical_name_sym( v )
            value = Fortnox::API::Registry[ name ].call( v )
            pairs << "\"#{ k }\":#{ value }"
          end
          "{#{ pairs.join(',') }}"
        end

        Registry.register( :hash, Fortnox::API::Mapper::Base::Hash )

        def self.canonical_name_sym( *values )
          klass = values.empty? ? self : values.first.class
          klass.name.split('::').last.downcase.to_sym
        end

        def self.call( hash )
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

        def diff( entity_hash, parent_hash, unique_id )
          hash_diff( entity_hash[self.class::JSON_ENTITY_WRAPPER],
                     parent_hash[self.class::JSON_ENTITY_WRAPPER],
                     unique_id )
        end

        private_class_method

          def self.convert_hash_keys_to_json_format( hash )
            hash.each_with_object( {} ) do |(key, value), json_hash|
              json_hash[ convert_key_to_json( key ) ] = value
            end
          end

          def self.convert_key_to_json( key )
            self::KEY_MAP.fetch( key ){ default_key_to_json_transform( key ) }
          end

          def self.default_key_to_json_transform( key )
            key.to_s.split('_').map(&:capitalize).join('')
          end

          def self.delegate_to_nested_mapper( key, nested_data )
            nested_mapper = self::NESTED_MAPPERS.fetch( key )

            if nested_data.is_a?( ::Array )
              nested_data.each_with_object( [] ) do |nested_model, array|
                array << nested_mapper.call( nested_model )
              end
            else # Hash assumed
              nested_mapper.call( nested_data )
            end
          end

          def self.convert_value_to_json_format( value )
            Fortnox::API::Registry[ canonical_name_sym( value ) ].call( value )
          end

        private

          def hash_diff(hash1, hash2, unique_id)
            hash1.dup.
              delete_if{ |k, v| hash2[k] == v unless k == unique_id }.
              merge!(hash2.dup.delete_if{ |k, _| hash1.has_key?(k) unless k == unique_id })
          end
      end
    end
  end
end
