require "vanguard"

module Fortnox
  module API
    module Entities
      module BaseValidator

        def validate( instance )
          raise ArgumentError, "No validator given for #{name}" unless @validator

          validation_result = @validator.call( instance )
          @violations = validation_result.violations

          return validation_result.valid?
        end

        def violations
          @violations ||= Set.new
        end

        def using_validations &block
          @validator = Vanguard::Validator.build( &block )
        end

        def instance
          raise ArgumentError, "No validator given for #{name}" unless @validator

          self
        end

      end
    end
  end
end
