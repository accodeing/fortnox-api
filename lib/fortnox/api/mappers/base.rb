require "fortnox/api/mappers/base/from_json"
require "fortnox/api/mappers/base/to_json"

module Fortnox
  module API
    module Mapper
      class Base
        include FromJSON
        include ToJSON

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

        def diff( entity_hash, parent_hash, unique_id )
          hash_diff( entity_hash[self.class::JSON_ENTITY_WRAPPER],
                     parent_hash[self.class::JSON_ENTITY_WRAPPER],
                     unique_id )
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
