require "vanguard"

module Fortnox
  module API
    module Validator
      module Base

        def validate( instance )
          raise_error_if_no_validator

          validation_result = @validator.call( instance )
          @violations = validation_result.violations

          return validation_result.valid?
        end

        def violations
          raise_error_if_no_validator

          @violations ||= Set.new
        end

        def using_validations &block
          @validator = Vanguard::Validator.build( &block )
        end

        def instance
          raise_error_if_no_validator

          self
        end

        private

          def raise_error_if_no_validator
            raise ArgumentError, "No validator given" unless @validator
          end
      end
    end
  end
end
