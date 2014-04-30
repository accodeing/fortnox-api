require "fortnox/api/customer/repository"
require "fortnox/api/customer/validator"
require "fortnox/api/customer/entity"

module Fortnox
  module API
    module Customer

      def self.new( hash = {} )
        Entity.new( hash )
      end

    end
  end
end
