# frozen_string_literal: true

module Fortnox
  module API
    module Types
      module Required
        String = Types::Strict::String.constructor { |value| value.to_s unless value.nil? }.is(:required)
        Integer = Types::Strict::Int.constructor { |value| value.to_i unless value.nil? }.is(:required)
        Float = Types::Strict::Float.constructor { |value| value.to_f unless value.nil? }.is(:required)
      end
    end
  end
end
