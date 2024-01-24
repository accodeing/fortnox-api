# frozen_string_literal: true

module Fortnox
  module API
    module Types
      class Model < Dry::Struct
        transform_types(&:omittable)
        transform_keys(&:to_sym)

        def initialize(input_attributes)
          if (missing_key = first_missing_required_key(input_attributes))
            error_message = "Missing attribute #{missing_key.inspect} in attributes: #{input_attributes}"
            raise Fortnox::API::MissingAttributeError, error_message
          end

          super
        end

        private

        def missing_keys(attributes)
          attribute_keys = attributes.compact.keys
          schema_keys = self.class.schema.keys.map(&:name)

          schema_keys - attribute_keys
        end

        def first_missing_required_key(attributes)
          missing_keys(attributes).find do |name|
            attribute = self.class.schema.keys.find { |key| key.name == name }
            attribute.type.respond_to?(:options) && attribute.type.options[:required]
          end
        end
      end
    end
  end
end
