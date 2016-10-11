require "fortnox/api/mappers/base"
require "fortnox/api/types"

module Fortnox
  module API
    module Mapper
      Identity = ->( value ){ value }

      String = ->( value ){ value.inspect }

      Boolean = ->( value ){ value.to_s.inspect }

      NilClass = ->( value ){ 'null' }

      Array = ->( value ) do
        pairs = value.map do |v|
          name = Fortnox::API::Mapper::Base.canonical_name_sym( v )
          Fortnox::API::Registry[ name ].call( v )
        end
        "[#{pairs.join(',')}]"
      end

      Registry.register( :fixnum, Fortnox::API::Mapper::Identity )
      Registry.register( :int, Fortnox::API::Mapper::Identity )
      Registry.register( :float, Fortnox::API::Mapper::Identity )
      Registry.register( :string, Fortnox::API::Mapper::String )
      Registry.register( :boolean, Fortnox::API::Mapper::Boolean )
      Registry.register( :nil, Fortnox::API::Mapper::NilClass )
      Registry.register( :array, Fortnox::API::Mapper::Array )
    end
  end
end
