require "fortnox/api/mappers/base/json_conversion"

module Fortnox
  module API
    module Mapper
      class Base
        include JSONConversion

        attr_reader :key_map

        def initialize( key_map )
          @key_map = key_map.freeze
        end
      end
    end
  end
end
