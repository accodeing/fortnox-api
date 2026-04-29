# frozen_string_literal: true

module Fortnox
  module Mappers
    # Base class for declarative struct mappers. Subclasses declare the target
    # struct, any API key overrides (acronyms like "EDIInformation" that the
    # PascalCase convention can't derive), and any read-only attributes that
    # should be excluded from serialisation.
    #
    #   class EmailInformation < Struct
    #     struct    Structs::EmailInformation
    #     overrides email_address_cc: 'EmailAddressCC'
    #   end
    class Struct
      CONVENTION = RestEasy::Conventions::PascalCase.new

      class << self
        def for(struct_class)
          Class.new(self) { struct struct_class }
        end

        def struct(klass)
          @struct_class = klass
        end

        def overrides(map)
          @overrides = map
        end

        def read_only(*names)
          @read_only_attributes = names
        end

        def parse(data)
          return nil if data.nil?

          attributes = data.transform_keys do |api_key|
            api_to_model_map[api_key] || CONVENTION.parse(api_key)
          end
          struct_class.new(attributes)
        end

        def serialise(struct)
          return nil if struct.nil?

          excluded = if struct.class.respond_to?(:read_only_attributes)
                       struct.class.read_only_attributes
                     else
                       []
                     end
          struct.to_h.except(*excluded).transform_keys do |key|
            model_to_api_map[key] || CONVENTION.serialise(key)
          end
        end

        private

        attr_reader :struct_class

        def model_to_api_map
          parent = if superclass.respond_to?(:send, true) && superclass != Struct
                     superclass.send(:model_to_api_map)
                   else
                     {}
                   end
          @overrides ? parent.merge(@overrides) : parent
        end

        def read_only_attributes
          parent = if superclass.respond_to?(:send, true) && superclass != Struct
                     superclass.send(:read_only_attributes)
                   else
                     []
                   end
          @read_only_attributes ? (parent + @read_only_attributes).uniq : parent
        end

        def api_to_model_map
          model_to_api_map.invert
        end
      end
    end
  end
end
