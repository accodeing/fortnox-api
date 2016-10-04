require 'date'

module Fortnox
  module API
    module Types

      module Nullable
        String = Types::Strict::String.optional.constructor{|value| value.to_s unless value.nil? }
        Float = Types::Strict::Float.optional.constructor{|value| value.to_f unless value.nil? }
        Integer = Types::Strict::Int.optional.constructor{|value| value.to_i unless value.nil? }
        Boolean = Types::Bool.optional.constructor{|value| THE_TRUTH.fetch( value ){ false }}
        Date = Types::Date.optional.constructor{|value| ::Date.parse( value ) unless value.nil? or value.is_a? ::Date }
      end

    end
  end
end
