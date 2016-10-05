require "fortnox/api/types"
require "ice_nine"

module Fortnox
  module API
    module Model
      class Base < Fortnox::API::Types::Model

        attr_accessor :unsaved

        def self.attribute( name, *args )
          define_method( "#{ name }?" ) do
            !send( name ).nil?
          end

          super
        end

        def self.new( hash = {} )
          obj = preserve_meta_properties( hash ) do
            super
          end

          IceNine.deep_freeze( obj )
        end

        def update( hash )
          old_attributes = self.to_hash
          new_attributes = old_attributes.merge( hash )

          return self if new_attributes == old_attributes

          new_hash = new_attributes.delete_if{ |_, value| value.nil? }
          new_hash[:new] = @new
          self.class.new( new_hash )
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

        # dry-types filter anything that isn't specified as an attribute on the
        # class that is being instansiated. This wrapper preserves the meta
        # properties we need to track object state during that initilisation and
        # sets them on the object after dry-types is done with it.
        def self.preserve_meta_properties( hash )
          is_unsaved = hash.delete( :unsaved ){ true }
          is_new = hash.delete( :new ){ true }

          obj = yield

          obj.instance_variable_set( :@unsaved, is_unsaved )
          obj.instance_variable_set( :@saved, !is_unsaved )
          obj.instance_variable_set( :@new, is_new )

          return obj
        end

        def private_attributes
          @@private_attributes ||= attribute_set.select{ |a| !a.public_writer? }
        end

      end
    end
  end
end
