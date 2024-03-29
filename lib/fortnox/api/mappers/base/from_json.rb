# frozen_string_literal: true

module Fortnox
  module API
    module Mapper
      module FromJSON
        class MissingModelOrMapperException < Fortnox::API::Exception
        end

        def wrapped_json_collection_to_entities_hash(json_collection_hash)
          entities_hash = []
          json_collection_hash[self.class::JSON_COLLECTION_WRAPPER].each do |json_hash|
            entities_hash << json_hash_to_entity_hash(json_hash, self.class::KEY_MAP)
          end

          entities_hash
        end

        def wrapped_json_hash_to_entity_hash(json_entity_hash)
          json_hash_to_entity_hash(json_entity_hash[self.class::JSON_ENTITY_WRAPPER],
                                   self.class::KEY_MAP)
        end

        private

        def json_hash_to_entity_hash(hash, key_map)
          hash.each_with_object({}) do |(key, value), json_hash|
            converted_key = convert_key_from_json(key, key_map)
            json_hash[converted_key] =
              if value.respond_to?(:each)
                convert_collection(key, value)
              else
                value
              end
          end
        end

        def convert_collection(key, collection)
          mapper_name = key.downcase
          if Registry.key?(mapper_name)
            convert_nested_data(mapper_name, key, collection)
          else
            # NOTE: This probably means this is a nested model that we have
            # not implemented yet, or that is missing a mapper.
            # Raise exception during test run if this happens so that we can
            # add it before a new release.

            message = "for #{key} (#{mapper_name}, #{Fortnox::API::Mapper::DefaultTemplates.canonical_name_sym}) " \
                      "with #{collection}"

            raise MissingModelOrMapperException, message if ENV['RUBY_ENV']

            Fortnox::API.logger.warn("Missing Model or Mapper implementation for #{key} with attributes: #{collection}")
            convert_hash_keys_from_json_format(collection, {})
          end
        end

        def convert_nested_data(_mapper_name, key, nested_data)
          nested_mapper = Registry[key.downcase]

          # Assume Hash of nested model
          return json_hash_to_entity_hash(nested_data, nested_mapper::KEY_MAP) unless nested_data.is_a?(::Array)

          # Array of nested models
          nested_data.each_with_object([]) do |value, nested_models|
            nested_models << json_hash_to_entity_hash(value, nested_mapper::KEY_MAP)
          end
        end

        def convert_key_from_json(key, key_map)
          key_map.key(key) || default_key_from_json_transform(key)
        end

        def default_key_from_json_transform(key)
          key = key.to_s
          key = camelcase_to_underscore(key) unless key.match?(/\A[A-Z]+\z/)
          key = strip_at_symbol(key) if key.match?(/\A@.*\z/)
          key.downcase.to_sym
        end

        def camelcase_to_underscore(key)
          key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2')
        end

        def strip_at_symbol(key)
          key.gsub(/\A@/, '')
        end
      end
    end
  end
end
