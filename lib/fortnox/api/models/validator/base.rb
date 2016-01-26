require "hanami/validations"

module Fortnox
  module API
    module Validators
      class Base < Delegator

        include Hanami::Validations

        def initialize(obj)
          super
          @delegate_sd_obj = obj
        end

        def __getobj__
          @delegate_sd_obj
        end

      end
    end
  end
end
