require "fortnox/api/entities/customer/repository"
require "fortnox/api/entities/customer/validator"
require "fortnox/api/entities/customer/entity"

module Fortnox
  module API
    module Entities
      module Customer

        def self.new( hash = {} )
          Entity.new( hash )
        end

      end
    end
  end
end
