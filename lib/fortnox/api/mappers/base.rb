require "fortnox/api/mappers/base/json_conversion"

module Fortnox
  module API
    module Mapper
      class Base
        include JSONConversion

        def initialize
          super
        end
      end
    end
  end
end
