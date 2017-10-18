require "fortnox/api/types"
require "ice_nine"

module Fortnox
  module API
    module Model
      class Base < Fortnox::API::Types::Model

        # TODO(jonas): Restructure this class a bit, it is not very readable.

        attr_accessor :unsaved, :parent

        def self.attribute( name, *args )
          define_method( "#{ name }?" ) do
            !send( name ).nil?
          end

          super
        end

        def self.new( hash )
          begin
            obj = preserve_meta_properties( hash ) do
              super( hash )
            end
          rescue Dry::Struct::Error => e
            raise Fortnox::API::AttributeError.new e
          end

          IceNine.deep_freeze( obj )
        end

        # This filtering logic could be improved since it is currently O(N*M).
        def attributes( *options )
          return self.class.schema if options.nil?

          options = Array(options)

          self.class.schema.find_all do |_name, attribute|
            options.all?{ |option| attribute.is?( option ) }
          end
        end

        def unique_id
          send( self.class::UNIQUE_ID )
        end

        def update( hash )
          old_attributes = self.to_hash
          new_attributes = old_attributes.merge( hash )

          return self if new_attributes == old_attributes

          new_hash = new_attributes.delete_if{ |_, value| value.nil? }
          new_hash[:new] = @new
          new_hash[:parent] = self
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

        def parent?
          not @parent.nil?
        end

        def parent
          @parent || self.class.new( self.class::STUB.dup )
        end

        def to_hash( recursive = false )
          return super() if recursive

          self.class.schema.keys.each_with_object({}) do |key, result|
            result[key] = self[key]
          end
        end

      private_class_method

        # dry-types filter anything that isn't specified as an attribute on the
        # class that is being instantiated. This wrapper preserves the meta
        # properties we need to track object state during that initilisation and
        # sets them on the object after dry-types is done with it.
        def self.preserve_meta_properties( hash )
          is_unsaved = hash.delete( :unsaved ){ true }
          is_new = hash.delete( :new ){ true }
          parent = hash.delete( :parent ){ nil }

          obj = yield

          # TODO: remove new, unsaved, saved
          obj.instance_variable_set( :@unsaved, is_unsaved )
          obj.instance_variable_set( :@saved, !is_unsaved )
          obj.instance_variable_set( :@new, is_new )
          obj.instance_variable_set( :@parent, parent )

          return obj
        end

      private

        def private_attributes
          @@private_attributes ||= attribute_set.select{ |a| !a.public_writer? }
        end

      end
    end
  end
end
