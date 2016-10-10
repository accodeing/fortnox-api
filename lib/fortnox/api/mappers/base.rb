require "fortnox/api/mappers/base/json_conversion"

module Fortnox
  module API
    module Mapper
      class Base
        include JSONConversion

        def initialize
          Fortnox::API::Registry.register( self.class.canonical_name_sym, self )
        end

        def self.canonical_name_sym
          self.name.split('::').last.to_sym
        end
      end
    end
  end
end
