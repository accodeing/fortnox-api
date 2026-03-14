# frozen_string_literal: true

module Fortnox
  module Parsers
    module Date
      # TODO: Improve parsing!
      # In case date parsing fails, ArgumentError is thrown. Currently, it is rescued in Repository::Loaders.find.
      # That method assumes that the exception is due to invalid argument to the find method, which is not the case
      # if it is raised from here!
      def self.parse( date_string )
        return nil if date_sting.nil? or date_string == ""

        Date.parse(date_string)
      end

      def self.serialise( date )
        return date if date.nil? or date == ""

        date.strftime("%F")
      end
    end
  end
end
