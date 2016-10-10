require "fortnox/api/mappers/base"
require "fortnox/api/types"

module Fortnox
  module API
    module Mapper
      require "fortnox/api/mappers/array"

      Identity = ->( value ){ value }

      String = ->( value ){ value.inspect }

      Boolean = ->( value ){ value.to_s.inspect }

      Array = ->( value ) do
        pairs = value.map do |v|
          name = Fortnox::API::Mapper::Base.canonical_name_sym( v )
          Fortnox::API::Registry[ name ].call( v )
        end
        "[#{pairs.join(',')}]"
      end

      Hash = ->( value ) do
        pairs = value.inject([]) do |pairs,(k,v)|
          name = Fortnox::API::Mapper::Base.canonical_name_sym( v )
          value = Fortnox::API::Registry[ name ].call( v )
          pairs << "\"#{ k }\":#{ value }"
        end
        "{#{pairs.join(',')}}"
      end

      Fortnox::API::Registry.register( :fixnum, Fortnox::API::Mapper::Identity )
      Fortnox::API::Registry.register( :int, Fortnox::API::Mapper::Identity )
      Fortnox::API::Registry.register( :float, Fortnox::API::Mapper::Identity )
      Fortnox::API::Registry.register( :string, Fortnox::API::Mapper::String )
      Fortnox::API::Registry.register( :boolean, Fortnox::API::Mapper::Boolean )
      Fortnox::API::Registry.register( :array, Fortnox::API::Mapper::Array )
      Fortnox::API::Registry.register( :hash, Fortnox::API::Mapper::Hash )
    end
  end
end
