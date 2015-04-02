require "virtus"
require "ice_nine"

module Fortnox
  module API
    class Entity

      extend Forwardable
      include Virtus.model

      attr_accessor :unsaved

      def initialize( hash = {} )
        @unsaved = hash.delete( :unsaved ){ true }
        super
        alias_attribute_accessors
        IceNine.deep_freeze( self )
      end

      def update( hash )
        p "Update called with #{hash}"
        attributes = self.to_hash.merge( hash )
        p "#{attributes} == #{self.to_hash}, returning #{self}" if attributes == self.to_hash
        return self if attributes == self.to_hash
        n = self.class.new( attributes )
        p "#{attributes} != #{self.to_hash}, returning #{n}"
        return n
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

      def string=( value )
        self.update( "string" => value )
      end

    private

      def alias_attribute_accessors
        attribute_set.each do |attribute|
          name = attribute.options[ :name ]
  
          self.define_singleton_method "#{name}=" do | value |
            p "Called as #{name}=, redirecting to update( #{name} => #{value} )"
            r = self.update( name => value )
            p "Got #{r} back from update"
            return r
          end
        end
      end

    end
  end
end
