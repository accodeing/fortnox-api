require "virtus"
require "ice_nine"

module Fortnox
  module API
    module Model
      class Base

        # extend Forwardable
        include Virtus.model

        attr_accessor :unsaved

        def self.attribute( name, *args )
          define_method( "#{name}?" ) do
            !send( name ).nil?
          end

          super
        end

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

        # Override to_hash to manage nested models correctly
        def to_hash *args
          hash_nested_models(super)
        end

      private

        def private_attributes
          @@private_attributes ||= attribute_set.select{ |a| !a.public_writer? }
        end

        # Turns nested models to hash
        def hash_nested_models(hash)
          hash.each do |k,v|
            if v.respond_to?(:to_hash)
              hash[k] = v.to_hash
            elsif v.is_a?(Array)
              hash[k] = v.map(&:to_hash)
            end
          end
        end
      end
    end
  end
end
