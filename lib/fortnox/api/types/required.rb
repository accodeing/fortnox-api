module Fortnox
  module API
    module Types

      module Required
        String = Types::Strict::String.with( required: true ).constructor{|value| value.to_s unless value.nil? }
        Float = Types::Strict::Float.with( required: true ).constructor{|value| value.to_f unless value.nil? }
      end

    end
  end
end
