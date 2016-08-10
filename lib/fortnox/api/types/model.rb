module Fortnox
  module API
    module Types
      class Model < Dry::Types::Struct
        constructor_type(:symbolized)

        def initialize( input_attributes )
          if missing_key = first_missing_required_key( input_attributes )
            raise Dry::Types::SchemaKeyError.new( missing_key )
          end

          super
        end

      private

        def missing_keys( attributes )
          non_nil_attributes = attributes.select{|_,value| !value.nil?}

          attribute_keys = non_nil_attributes.keys
          schema_keys =  self.class.schema.keys

          schema_keys - attribute_keys
        end

        def first_missing_required_key( attributes )
          all_missing_keys = missing_keys( attributes )
          missing_required = all_missing_keys.select do |name|
            self.class.schema[ name ].options[:required]
          end

          missing_required.first
        end
      end
    end
  end
end
