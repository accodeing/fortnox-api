# frozen_string_literal: true

require 'dry-struct'

module Fortnox
  class Struct < Dry::Struct
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
    end
  end
end
