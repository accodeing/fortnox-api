# frozen_string_literal: true

require 'date'

module Fortnox
  module API
    module Types
      module Nullable
        String = Types::Strict::String.optional.constructor { |value| value&.to_s }
        Float = Types::Strict::Float.optional.constructor { |value| value&.to_f }
        Integer = Types::Strict::Int.optional.constructor { |value| value&.to_i }
        Boolean = Types::Bool.optional.constructor { |value| THE_TRUTH.fetch(value) { false } }
        # TODO: Improve parsing!
        # In case date parsing fails, ArgumentError is thrown. Currently, it is rescued in Repository::Loaders.find.
        # That method assumes that the exception is due to invalid argument to the find method, which is not the case
        # if it is raised from here!
        Date = Types::Date.optional.constructor { |value| ::Date.parse(value.to_s) unless value.nil? || value == '' }
      end
    end
  end
end
