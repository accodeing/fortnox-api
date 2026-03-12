# frozen_string_literal: true

module Fortnox
  module Parsers
    module Labels
      def self.parse( labels )
        return [] unless labels.is_a?(Array)

        labels.map do |label|
          Fortnox::Label.new(label)
        end
      end

      def self.serialise( labels )
        return [] if labels.nil?
        return [] unless labels.is_a?(Array)

        labels.map do |label|
          label.serialise
        end
      end
    end
  end
end
