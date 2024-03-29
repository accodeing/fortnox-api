# frozen_string_literal: true

require 'ice_nine'

require_relative '../types'

module Fortnox
  module API
    module Model
      class Base < Fortnox::API::Types::Model
        # TODO(jonas): Restructure this class a bit, it is not very readable.

        attr_accessor :unsaved
        attr_writer :parent

        def self.attribute(name, *args)
          define_method("#{name}?") do
            !send(name).nil?
          end

          super
        end

        def self.new(hash = {})
          begin
            obj = preserve_meta_properties(hash) do
              super(hash)
            end
          rescue Dry::Struct::Error => exception
            raise Fortnox::API::AttributeError, exception
          end

          IceNine.deep_freeze(obj)
        end

        def self.stub
          new(self::STUB.dup)
        end

        def unique_id
          send(self.class::UNIQUE_ID)
        end

        # This filtering logic could be improved since it is currently O(N*M).
        def attributes(*options)
          return self.class.schema if options.nil?

          options = Array(options)

          self.class.schema.find_all do |_name, attribute|
            options.all? { |option| attribute.is?(option) }
          end
        end

        def to_hash(recursive = false) # rubocop:disable Style/OptionalBooleanParameter
          return super() if recursive

          self.class.schema.each_with_object({}) do |key, result|
            # Only output attributes that have a value set
            result[key.name] = self[key.name] if send("#{key.name}?")
          end
        end

        def update(hash)
          old_attributes = to_hash
          new_attributes = old_attributes.merge(hash).compact

          return self if new_attributes == old_attributes

          new_attributes[:new] = @new
          new_attributes[:parent] = self
          self.class.new(new_attributes)
        end

        # Generic comparison, by value, use .eql? or .equal? for object identity.
        def ==(other)
          return false unless other.is_a? self.class

          to_hash == other.to_hash
        end

        def new?
          @new
        end

        def saved?
          @saved
        end

        def parent?
          !@parent.nil?
        end

        def parent
          @parent || self.class.new(self.class::STUB.dup)
        end

        # dry-types filter anything that isn't specified as an attribute on the
        # class that is being instantiated. This wrapper preserves the meta
        # properties we need to track object state during that initialisation and
        # sets them on the object after dry-types is done with it.
        def self.preserve_meta_properties(hash)
          is_unsaved = hash.delete(:unsaved) { true }
          is_new = hash.delete(:new) { true }
          parent = hash.delete(:parent) { nil }

          obj = yield

          # TODO: remove new, unsaved, saved
          obj.instance_variable_set(:@unsaved, is_unsaved)
          obj.instance_variable_set(:@saved, !is_unsaved)
          obj.instance_variable_set(:@new, is_new)
          obj.instance_variable_set(:@parent, parent)

          obj
        end

        private_class_method :preserve_meta_properties

        private

        def private_attributes
          @private_attributes ||= attribute_set.reject(&:public_writer?)
        end
      end
    end
  end
end
