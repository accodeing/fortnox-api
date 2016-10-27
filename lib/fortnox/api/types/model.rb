module Fortnox
  module API
    module Types
      class Model < Dry::Struct
        constructor_type(:schema)

        def initialize( input_attributes )
          if (missing_key = first_missing_required_key( input_attributes ))
            raise Fortnox::API::MissingAttributeError.new( "Missing attribute #{ missing_key.inspect } in attributes: #{ input_attributes }" )
          end

          super
        end

      private

        def missing_keys( attributes )
          non_nil_attributes = attributes.select{ |_,value| !value.nil? }

          attribute_keys = non_nil_attributes.keys
          schema_keys =  self.class.schema.keys

          schema_keys - attribute_keys
        end

        def first_missing_required_key( attributes )
          all_missing_keys = missing_keys( attributes )
          missing_required = all_missing_keys.select do |name|
            attribute = self.class.schema[ name ]
            next unless attribute.respond_to? :options
            attribute.options[:required]
          end

          missing_required.first
        end
      end

    end
  end
end
