require "virtus"
require "ice_nine"

module Fortnox
  module API
    module Entities
      class Base

        extend Forwardable
        include Virtus.model

        attr_accessor :unsaved

        def initialize( hash = {} )
          @unsaved = hash.delete( :unsaved ){ true }
          super
          IceNine.deep_freeze( self )
        end

        def update( hash )
          attributes = self.to_hash.merge( hash )

          return self if attributes == self.to_hash

          self.class.new( attributes )
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
end
