module Fortnox
  module API
    module Validator
      module Constant

        def validate( _ )
          true
        end

        def violations
          Set.new
        end

        def instance
          self
        end
      end
    end
  end
end
