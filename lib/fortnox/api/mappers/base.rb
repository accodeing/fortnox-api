# frozen_string_literal: true

require 'fortnox/api/mappers/base/from_json'
require 'fortnox/api/mappers/base/to_json'

module Fortnox
  module API
    module Mapper
      class Base
        include FromJSON
        include ToJSON

        def self.canonical_name_sym(*values)
          klass = if values.empty?
                    self
                  elsif values.first.is_a? Class
                    values.first
                  else
                    values.first.class
                  end

          if RUBY_VERSION >= '2.4'
            # Ruby 2.4 unifies Fixnum and Bignum into Integer
            # Stringify to avoid warnings on newer Ruby versions
            klass = Integer if %w[Bignum Fixnum].include?(klass.to_s)
          end

          klass.name.split('::').last.downcase.to_sym
        end

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
