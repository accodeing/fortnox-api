# frozen_string_literal: true

module Fortnox
  module API
    module Types
      module Required
        String = Types::Strict::String.constructor { |value| value&.to_s }.is(:required)
        Integer = Types::Strict::Integer.constructor { |value| value&.to_i }.is(:required)
        Float = Types::Strict::Float.constructor { |value| value&.to_f }.is(:required)
      end
    end
  end
end
