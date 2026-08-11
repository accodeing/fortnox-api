# frozen_string_literal: true

module Fortnox
  # JSON rendering for the three types a consumer can hold.
  #
  # rest-easy generates JSON straight from the attribute hash, and `JSON`
  # renders anything it doesn't recognise through `to_s`. Nested structs are
  # the case that matters: without this, an invoice with rows serialises them
  # as `"#<Fortnox::Structs::InvoiceRow:0x…>"`.
  #
  # All three render the model representation — snake_case attribute names —
  # not the Fortnox wire format. Use `to_api` for the latter.
  module Serialisation
    # Applies Rails' `:only` / `:except` render options.
    #
    # ActiveSupport's `Hash#as_json` slices a symbol-keyed hash, so a caller
    # passing `only: ['name']` would match nothing and silently render `{}`.
    # Normalise both sides instead, and accept either spelling.
    #
    # Anything that isn't an options hash is ignored — `JSON.generate` passes a
    # `JSON::State` here when a resource is nested inside another structure.
    def self.filter(attributes, options)
      return attributes unless options.is_a?(::Hash)

      if options[:only]
        attributes.slice(*Array(options[:only]).map(&:to_sym))
      elsif options[:except]
        attributes.except(*Array(options[:except]).map(&:to_sym))
      else
        attributes
      end
    end

    # Converts model values into JSON-safe primitives.
    def self.json_safe(value)
      case value
      when Fortnox::Struct then json_safe(value.to_h)
      when ::Hash then value.to_h { |key, nested| [key.to_s, json_safe(nested)] }
      when ::Array then value.map { |element| json_safe(element) }
      else value
      end
    end

    module ResourceJSON
      def to_json(options = nil)
        ::JSON.generate(Serialisation.json_safe(Serialisation.filter(model.attributes, options)))
      end
    end

    module StructJSON
      def to_json(options = nil)
        ::JSON.generate(Serialisation.json_safe(Serialisation.filter(to_h, options)))
      end
    end

    module CollectionJSON
      # Renders as its records, the way an Array of them would. Pagination
      # metadata stays addressable on the collection for callers that want to
      # render it alongside.
      def to_json(options = nil)
        rendered = to_a.map do |item|
          Serialisation.json_safe(Serialisation.filter(item.model.attributes, options))
        end
        ::JSON.generate(rendered)
      end
    end
  end
end
