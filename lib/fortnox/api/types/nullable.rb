# frozen_string_literal: true

require 'date'

module Fortnox
  module API
    module Types
      module Nullable
        String = Types::Strict::String.optional.constructor { |value| value&.to_s }
        Float = Types::Strict::Float.optional.constructor { |value| value&.to_f }
        Integer = Types::Strict::Integer.optional.constructor { |value| value&.to_i }
        Boolean = Types::Bool.optional.constructor { |value| THE_TRUTH.fetch(value, false) }
        Date = Types::Date.optional.constructor do |value|
          next if value.nil? || value == ''

          begin
            ::Date.parse(value.to_s)
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end
