module Fortnox
  module API
    module Types

      module Required
        String = Types::Strict::String.constructor{|value| value.to_s unless value.nil? }.with( required: true )
        Float = Types::Strict::Float.constructor{|value| value.to_f unless value.nil? }.with( required: true )
      end

    end
  end
end
