# frozen_string_literal: true

module Fortnox
  module Parsers
    module StructArray
      def self.for(klass)
        Handler.new(Struct.for(klass))
      end

      class Handler
        def initialize(struct_parser)
          @struct_parser = struct_parser
        end

        def parse(data)
          return [] if data.nil?
          raise Fortnox::AttributeError, "Expected Array, got #{data.class}" unless data.is_a?(Array)

          data.map { |item| @struct_parser.parse(item) }
        end

        def serialise(structs)
          return [] if structs.nil?
          raise Fortnox::AttributeError, "Expected Array, got #{structs.class}" unless structs.is_a?(Array)

          structs.map { |struct| @struct_parser.serialise(struct) }
        end
      end
    end
  end
end
