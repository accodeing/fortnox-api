# frozen_string_literal: true

require 'dry-struct'

module Fortnox
  class Struct < Dry::Struct
    include Serialisation::StructJSON

    # Accept the string keys Rails params arrive with.
    transform_keys(&:to_sym)

    # Reject attribute names the struct doesn't declare. Dry::Struct ignores
    # them by default, so a misspelled key silently produced an empty row that
    # Fortnox then accepted. Parsing stays tolerant of undeclared fields —
    # Mappers::Struct slices API data to the declared attributes first.
    schema schema.strict

    # Lets us tell "no attributes given" apart from "given an empty hash", so
    # Dry::Struct still gets to apply its own defaults in the former case.
    NO_ATTRIBUTES = ::Object.new.freeze
    private_constant :NO_ATTRIBUTES

    class << self
      def read_only_attributes
        @read_only_attributes ||=
          (superclass.respond_to?(:read_only_attributes) ? superclass.read_only_attributes.dup : [])
      end

      def attribute(name, type, *flags)
        read_only_attributes << name if flags.include?(:read_only)
        super(name, type)
      end

      def attribute?(name, type, *flags)
        read_only_attributes << name if flags.include?(:read_only)
        super(name, type)
      end

      # Dry::Struct signals a bad value with Dry::Struct::Error, a TypeError
      # that sits outside the Fortnox::Error hierarchy — so a caller's
      # `rescue Fortnox::AttributeError` misses it and the failure surfaces as
      # an unhandled crash. Structs are reachable through the same public
      # entry points as resources (`Resource.stub` coerces nested hashes into
      # structs), so they translate their errors the same way.
      # rubocop:disable Style/OptionalBooleanParameter
      # `safe` is Dry::Struct's own second positional parameter — it picks the
      # non-raising coercion path — so it has to stay positional here. We only
      # pass it through.
      def new(attributes = NO_ATTRIBUTES, safe = false, &)
        return super() if NO_ATTRIBUTES.equal?(attributes)

        super
      rescue Dry::Struct::Error => e
        raise translated_error(e, attributes)
      end
      # rubocop:enable Style/OptionalBooleanParameter

      # Attribute names this struct accepts.
      def attribute_names
        schema.keys.map(&:name)
      end

      private

      def translated_error(error, attributes)
        return Fortnox::AttributeError.new(error.message) unless attributes.is_a?(::Hash)

        unknown_attribute_error(attributes) ||
          failing_attribute_error(attributes) ||
          Fortnox::AttributeError.new(error.message)
      end

      # Dry::Struct reports a strict-schema rejection as "unexpected keys […]"
      # in the message only. Recompute the names from the input rather than
      # parsing that string back out.
      def unknown_attribute_error(attributes)
        unknown = AttributeKeys.normalise(attributes).keys - attribute_names
        return nil if unknown.empty?

        Fortnox::UnknownAttributeError.new(unknown, self)
      end

      # Dry::Struct discards the underlying coercion error, keeping only its
      # message, so re-run each value through its own key type to recover
      # which attribute was at fault and what it was given.
      def failing_attribute_error(attributes)
        keys = schema.keys.to_h { |key| [key.name, key] }

        attributes.each do |name, value|
          key = keys[name.to_s.to_sym]
          next if key.nil?

          error = coercion_error_for(key, value)
          return error if error
        end

        nil
      end

      def coercion_error_for(key, value)
        key.call(value)
        nil
      rescue Dry::Types::CoercionError => e
        # Report the key type's own message rather than Dry::Struct's wrapper,
        # so struct and resource failures read identically.
        Fortnox::ConstraintError.new(key.name, value, "Attribute '#{key.name}': #{e.message}")
      end
    end
  end
end
