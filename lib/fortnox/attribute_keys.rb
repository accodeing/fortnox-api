# frozen_string_literal: true

module Fortnox
  # Checks the attribute names a caller passes to `new`, `stub` and `update`.
  #
  # Both rest-easy and Dry::Struct build from the attributes they recognise and
  # ignore everything else, so a typo or a string key used to vanish without a
  # word: the request went out missing that field and Fortnox accepted it. The
  # bigger the payload, the easier that is to miss.
  #
  # This only guards data a caller supplies. Parsing an API response stays
  # tolerant of fields the gem doesn't declare — Fortnox adds them over time,
  # and a response must not fail to parse because of one.
  module AttributeKeys
    module_function

    def check(data, known:, subject:)
      normalised = normalise(data)
      unknown = normalised.keys - known
      raise Fortnox::UnknownAttributeError.new(unknown, subject) unless unknown.empty?

      normalised
    end

    # Rails hands params through with string keys. Accept them rather than
    # reporting every attribute in the hash as unknown.
    def normalise(data)
      data.to_h { |key, value| [key.respond_to?(:to_sym) ? key.to_sym : key, value] }
    end
  end
end
