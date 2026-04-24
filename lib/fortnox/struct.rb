# frozen_string_literal: true

require 'dry-struct'

module Fortnox
  class Struct < Dry::Struct
    CONVENTION = RestEasy::Conventions::PascalCase.new

    class << self
      def attr(name_or_mapping, type, *flags) # rubocop:disable Naming/PredicateMethod
        model_name, api_name = resolve_names(name_or_mapping)

        api_key_map[api_name] = model_name
        model_key_map[model_name] = api_name
        read_only_attributes << model_name if flags.include?(:read_only)

        attribute? model_name, type
      end

      def api_key_map
        @api_key_map ||= (superclass.respond_to?(:api_key_map) ? superclass.api_key_map.dup : {})
      end

      def model_key_map
        @model_key_map ||= (superclass.respond_to?(:model_key_map) ? superclass.model_key_map.dup : {})
      end

      def read_only_attributes
        @read_only_attributes ||=
          (superclass.respond_to?(:read_only_attributes) ? superclass.read_only_attributes.dup : [])
      end

      private

      def resolve_names(name_or_mapping)
        if name_or_mapping.is_a?(::Array)
          [name_or_mapping[0].to_sym, name_or_mapping[1].to_s]
        else
          name = name_or_mapping.to_sym
          [name, CONVENTION.serialise(name)]
        end
      end
    end

    def to_api_hash
      key_map = self.class.model_key_map
      read_only = self.class.read_only_attributes

      to_hash.except(*read_only).transform_keys do |key|
        key_map[key] || CONVENTION.serialise(key)
      end
    end

    transform_keys do |key|
      CONVENTION.parse(key)
    end
  end
end
