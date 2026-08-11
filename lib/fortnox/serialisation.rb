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
      def to_json(*_args)
        ::JSON.generate(Serialisation.json_safe(model.attributes))
      end
    end

    module StructJSON
      def to_json(*_args)
        ::JSON.generate(Serialisation.json_safe(to_h))
      end
    end

    module CollectionJSON
      # Renders as its records, the way an Array of them would. Pagination
      # metadata stays addressable on the collection for callers that want to
      # render it alongside.
      def to_json(*_args)
        ::JSON.generate(to_a.map { |item| Serialisation.json_safe(item.model.attributes) })
      end
    end
  end
end
