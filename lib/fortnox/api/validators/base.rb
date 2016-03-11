require "vanguard"

module Fortnox
  module API
    module Validator
      class Base

        @validators = []

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

        def self.using_validations &block
          @validators << Vanguard::Validator.build( &block )
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
