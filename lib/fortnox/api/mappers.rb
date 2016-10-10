require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      require "fortnox/api/mappers/array"

      Int = ->( value ){ value }
      Float = ->( value ){ value }
      String = ->( value ){ value }

      Fortnox::API::Registry.register( :int, Fortnox::API::Mapper::Int )
      Fortnox::API::Registry.register( :float, Fortnox::API::Mapper::Float )
      Fortnox::API::Registry.register( :string, Fortnox::API::Mapper::String )
    end
  end
end
