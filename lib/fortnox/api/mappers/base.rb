require "fortnox/api/mappers/base/json_conversion"

module Fortnox
  module API
    module Mapper
      class Base
        include JSONConversion

        Hash = ->( value ) do
          pairs = value.inject([]) do |pairs,(k,v)|
            name = Fortnox::API::Mapper::Base.canonical_name_sym( v )
            value = Fortnox::API::Registry[ name ].call( v )
            pairs << "\"#{ k }\":#{ value }"
          end
          "{#{pairs.join(',')}}"
        end

        Registry.register( :hash, Fortnox::API::Mapper::Base::Hash )

        def self.canonical_name_sym( value = nil )
          klass = value ? value.class : self
          klass.name.split('::').last.downcase.to_sym
        end

        def self.call( hash )
          translate_keys( hash )
          translate_values( hash )
          Registry[:hash].call( hash )
        end

        private_class_method

        def self.translate_keys( hash )
          hash.keys.each do |key|
            if self::KEY_MAP.key?( key )
              hash[self::KEY_MAP.fetch( key )] = hash.delete( key )
            end
          end
        end

        def self.translate_values( hash )
          hash.each do |key, value|
            hash[key] = Registry[value.class.name.downcase.to_sym].call( value )
          end
        end
      end
    end
  end
end
