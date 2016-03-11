require "vanguard"

module Fortnox
  module API
    module Validator

      module Mixin
        class << self
          def included( base )
            base.extend ClassMethods
          end
        end

        module ClassMethods
          def using_validations &block
            @validators ||= []
            @validators << Vanguard::Validator.build( &block )
          end

          def validators
            @validators || []
          end
        end
      end

      class Base

        include Mixin

        def validate( instance )
          raise_error_if_no_validator

          valid = true

          validators.each do |validator|
            validation_result = validator.call( instance )
            violations.merge( validation_result.violations )
            valid = valid && validation_result.valid?
          end

          return valid
        end

        def violations
          raise_error_if_no_validator

          @violations ||= Set.new
        end

        def instance
          raise_error_if_no_validator

          self
        end

      private

        def validators
          self.class.validators
        end

        def raise_error_if_no_validator
          return if validators.length > 0
          raise ArgumentError, "No validator given"
        end

      end
    end
  end
end
