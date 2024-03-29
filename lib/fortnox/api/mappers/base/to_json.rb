# frozen_string_literal: true

module Fortnox
  module API
    module Mapper
      module ToJSON
        def self.included(base)
          base.send :extend, ClassMethods

          base.send :private_class_method,
                    :convert_hash_keys_to_json_format,
                    :convert_key_to_json,
                    :default_key_to_json_transform,
                    :sanitise
        end

        module ClassMethods
          def call(entity, keys_to_filter = {})
            entity_hash = entity.to_hash
            clean_entity_hash = sanitise(entity_hash, keys_to_filter)
            clean_entity_hash = convert_hash_keys_to_json_format(clean_entity_hash)
            Registry[:hash].call(clean_entity_hash)
          end

          # PRIVATE

          def convert_hash_keys_to_json_format(hash)
            hash.transform_keys do |key|
              convert_key_to_json(key)
            end
          end

          def convert_key_to_json(key)
            self::KEY_MAP.fetch(key) { default_key_to_json_transform(key) }
          end

          def default_key_to_json_transform(key)
            key.to_s.split('_').map(&:capitalize).join
          end

          def sanitise(hash, keys_to_filter)
            hash.reject do |key, value|
              keys_to_filter.include?(key) || value.nil?
            end
          end
        end

        def entity_to_hash(entity, keys_to_filter)
          entity_json_hash = Registry[mapper_name_for(entity)]
                             .call(entity, keys_to_filter)
          wrap_entity_json_hash(entity_json_hash)
        end

        def wrap_entity_json_hash(entity_json_hash)
          { self.class::JSON_ENTITY_WRAPPER => entity_json_hash }
        end

        private

        def mapper_name_for(value)
          value.class.name.split('::').last.downcase.to_sym
        end
      end
    end
  end
end
