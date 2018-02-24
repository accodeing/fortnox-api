# frozen_string_literal: true

module Fortnox
  module API
    module Types
      class Model < Dry::Struct
        constructor_type(:schema)

        def initialize(input_attributes)
          if (missing_key = first_missing_required_key(input_attributes))
            error_message = "Missing attribute #{missing_key.inspect} in attributes: #{input_attributes}"
            raise Fortnox::API::MissingAttributeError, error_message
          end

          super
        end

        private

        def missing_keys(attributes)
          non_nil_attributes = attributes.reject { |_, value| value.nil? }

          attribute_keys = non_nil_attributes.keys
          schema_keys =  self.class.schema.keys

          schema_keys - attribute_keys
        end

        def first_missing_required_key(attributes)
          missing_keys(attributes).find do |name|
            attribute = self.class.schema[name]
            attribute.respond_to?(:options) && attribute.options[:required]
          end
        end
      end
    end
  end
end
