# frozen_string_literal: true

module Fortnox
  module Mappers
    module StructArray
      def self.for(mapper)
        Handler.new(mapper)
      end

      class Handler
        def initialize(mapper)
          @mapper = mapper
        end

        def parse(data)
          return [] if data.nil?
          raise Fortnox::AttributeError, "Expected Array, got #{data.class}" unless data.is_a?(Array)

          data.map { |item| @mapper.parse(item) }
        end

        def serialise(structs)
          return [] if structs.nil?
          raise Fortnox::AttributeError, "Expected Array, got #{structs.class}" unless structs.is_a?(Array)

          structs.map { |struct| @mapper.serialise(struct) }
        end
      end
    end
  end
end
