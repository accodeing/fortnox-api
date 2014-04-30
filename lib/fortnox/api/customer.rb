require "fortnox/api/customer/repository"
require "fortnox/api/customer/validator"
require "fortnox/api/customer/entity"

module Fortnox
  module API
    module Customer

      def self.new( hash = {} )
        normalize_keys!( hash )
        Entity.new( hash )
      end

      def self.new_from_json( hash )
        new hash['Customer']
      end

    end
  end
end
