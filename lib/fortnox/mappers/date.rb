# frozen_string_literal: true

require 'date'

module Fortnox
  module Mappers
    module Date
      def self.parse(date_string)
        return nil if date_string.nil? || (date_string == '')

        ::Date.parse(date_string)
      end

      def self.serialise(date)
        return date if date.nil? || (date == '')

        date.strftime('%F')
      end
    end
  end
end
