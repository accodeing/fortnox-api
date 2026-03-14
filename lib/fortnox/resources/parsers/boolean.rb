# frozen_string_literal: true

module Fortnox
  module Parsers
    module Date
      def self.parse( boolean_string )
        return nil if boolean_sting.nil?

        THE_TRUTH.fetch(boolean_string, false)
      end

      def self.serialise( boolean ) boolean
    end
  end
end
