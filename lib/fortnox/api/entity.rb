require "virtus"
require "ice_nine"

module Fortnox
  module API
    class Entity

      include Virtus.model

      def initialize( * )
        super
        IceNine.deep_freeze( self )
      end

      def update( hash )
        self.class.new( self.to_hash.merge( hash ))
      end

      # Generic comparison, by value, use .eql? or .equal? for object identity.
      def ==( other )
        return false unless other.is_a? self.class
        self.to_hash == other.to_hash
      end

      def to_json
        hash = attribute_set.each_with_object({}) do |attribute, hash|
          name = attribute.options[ :name ]
          key = attribute.options[ :json_name ] || attribute_name_to_json( name )
          value = attributes[name]
          hash[ key ] = value
        end
        hash.to_json
      end

    end
  end
end
