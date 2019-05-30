# frozen_string_literal: true

require 'fortnox/api/mappers/base/canonical_name_sym'
require 'fortnox/api/mappers/base/from_json'
require 'fortnox/api/mappers/base/to_json'

module Fortnox
  module API
    module Mapper
      class Base
        include FromJSON
        include ToJSON
        extend CanonicalNameSym

        def diff(entity_hash, parent_hash)
          hash_diff(entity_hash[self.class::JSON_ENTITY_WRAPPER],
                    parent_hash[self.class::JSON_ENTITY_WRAPPER])
        end

        private

        def hash_diff(hash1, hash2)
          hash1.dup
               .delete_if { |k, v| hash2[k] == v }
               .merge!(hash2.dup.delete_if { |k, _| hash1.key?(k) })
        end
      end
    end
  end
end
