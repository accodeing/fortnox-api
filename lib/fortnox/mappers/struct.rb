# frozen_string_literal: true

module Fortnox
  module Mappers
    module Struct
      def self.for(klass)
        Module.new do
          define_singleton_method(:parse) { |data| klass.new(data) }
          define_singleton_method(:serialise) { |struct| struct&.to_api_hash }
        end
      end
    end
  end
end
