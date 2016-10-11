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

        def self.canonical_name_sym( *value )
          klass = value.empty? ? 'nil' : self
          klass.name.split('::').last.downcase.to_sym
        end

        def self.call( hash )
          translate_keys( hash )
          translate_values( hash )
          Registry[:hash].call( hash )
        end

        def diff( entity_hash, parent_hash, unique_id )
          hash_diff( entity_hash[self.class::JSON_ENTITY_WRAPPER],
                     parent_hash[self.class::JSON_ENTITY_WRAPPER],
                     unique_id )
        end

        private_class_method

          def self.translate_keys( hash )
            hash.keys.each do |key|
              if self::KEY_MAP.key?( key )
                hash[self::KEY_MAP.fetch( key )] = hash.delete( key )
              else
                key.to_s.inspect
              end
            end
          end

          def self.translate_values( hash )
            hash.each do |key, value|
              hash[key] = Registry[value.class.name.downcase.to_sym].call( value )
            end
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
