require "fortnox/api/mappers/base/json_conversion"

module Fortnox
  module API
    module Mapper
      class Base
        include JSONConversion

        def self.canonical_name_sym( value = nil )
          klass = value ? value.class : self
          klass.name.split('::').last.downcase.to_sym
        end
      end
    end
  end
end
