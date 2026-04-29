# frozen_string_literal: true

module Fortnox
  module Mappers
    module LabelReferences
      def self.parse(labels)
        return [] unless labels.is_a?(Array)

        labels.map do |label|
          Fortnox::Label.parse({ 'Label' => label })
        end
      end

      def self.serialise(labels)
        return [] if labels.nil?
        return [] unless labels.is_a?(Array)

        labels.map do |label|
          { 'Id' => label.id }
        end
      end
    end
  end
end
