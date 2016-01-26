require "virtus"
require "ice_nine"

module Fortnox
  module API
    module Entities
      class Base

        # extend Forwardable
        include Virtus.model

        attr_accessor :unsaved

        def initialize( hash = {} )
          unsaved = hash.delete( :unsaved ){ true }
          @saved = !unsaved
          @new = hash.delete( :new ){ true }

          # .each{|a| p a.name}

          super hash
          IceNine.deep_freeze( self )
        end

        def update( hash )
          old_attributes = self.to_hash
          new_attributes = old_attributes.merge( hash )

          return self if new_attributes == old_attributes

          self.class.new( new_attributes )
        end

        # Generic comparison, by value, use .eql? or .equal? for object identity.
        def ==( other )
          return false unless other.is_a? self.class
          self.to_hash == other.to_hash
        end

        def new?
          @new
        end

        def saved?
          @saved
        end

      private

        def private_attributes
          @@private_attributes ||= attribute_set.select{ |a| !a.public_writer? }
        end

      end
    end
  end
end
